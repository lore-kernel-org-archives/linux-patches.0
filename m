Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08E6149C6F;
	Thu, 25 Jun 2026 13:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392769; cv=none; b=Nh2kkN0TmpG/1RuC/E/+KzfBxS0Ll87HuQxcMNV12m5o38/B6ifR9jSUTvagl8MnFsk6rw/wMVzuMgiQNAsXE5fcv6t29c4NbfBK+hnK7olg+ZWN+EjHrwlYUQ7gI7irPXfhnuI1by8vf6Jh7trV20yp8SjprzqgvmY+/9ymP2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392769; c=relaxed/simple;
	bh=SD6Vi0dAttqcFo6ivFISd4EfGoPdb7gQb63k8ATlOFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHgT3ReFl6Axh+k7C8sQtxqgb6aH8HoRKhp23gtxBwnAPpOUTjz55NOxuh+TcTcsqyslzavztIChNfloWZaFRfVbFkEUtnQ6wFRRL7BFPUIBaoJdqhYhzoaXLTDj1HnSjYTO3QGE4xhJU5sAKPWH7ZKouMq9/Zjd2mAVb/YW7nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/yWJyv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/yWJyv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017121F000E9;
	Thu, 25 Jun 2026 13:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392766;
	bh=9d/k9HaobmEnc+LQM277Ii+TIGFvym55b3oFSE3r7rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/yWJyv5jVuUPFuxnAQMYhjwlwStKgzNqlLboEfz6GhadW0MfbtDTMrfRUytkTyb1
	 6shyGdpytXYQ2gligk3ZMlOFnDujqq29THfQkXwB7ff93bI9fWo3X1iWN1UCplbzB2
	 YmnQVGOB1iEJwmAwcaYKug0EHS6uITqh0qvrjFhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 17/60] rose: clear neighbour pointer after rose_neigh_put() in state machines
Date: Thu, 25 Jun 2026 14:03:02 +0100
Message-ID: <20260625125648.070352821@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit e8eb0c6faa8849ba7769516c1a8c84d9f612acf6 upstream.

After calling rose_neigh_put() in rose_state1_machine() through
rose_state5_machine(), rose->neighbour was left pointing at the
potentially freed neighbour structure.  A subsequent timer expiry or
concurrent teardown path could dereference the stale pointer, causing
a use-after-free.

Set rose->neighbour to NULL immediately after each rose_neigh_put()
call in the state machine functions.

Fixes: d860d1faa6b2 ("net: rose: convert 'use' field to refcount_t")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_in.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -57,6 +57,7 @@ static int rose_state1_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, ECONNREFUSED, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	default:
@@ -80,11 +81,13 @@ static int rose_state2_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	case ROSE_CLEAR_CONFIRMATION:
 		rose_disconnect(sk, 0, -1, -1);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	default:
@@ -122,6 +125,7 @@ static int rose_state3_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	case ROSE_RR:
@@ -235,6 +239,7 @@ static int rose_state4_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	default:
@@ -255,6 +260,7 @@ static int rose_state5_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose_sk(sk)->neighbour);
+		rose_sk(sk)->neighbour = NULL;
 	}
 
 	return 0;


