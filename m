Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C5529B77C;
	Thu, 25 Jun 2026 13:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393002; cv=none; b=oKUYQ7Px7j+gBScyoHbBZisUanIlz5rOEEKbIFgvFCQRAc1Q3vH2oKfcpIgIexIx091IrlvyjZC2yZ43DA5obvuBKj8OX6pbqQ8zu1RzrKJMNGs4TBWH+NClr5OqIdx9A/D4DDqJHuimyIlcBIxWadAOJOKpcaSB4E6Y/HX5vuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393002; c=relaxed/simple;
	bh=98ROPIKmV4zfIjaDob6iDw4xSzs5GCaTYqKoLvG5j4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jzl5BeHQKKzOPtdkehTOzHkPM0lgccFtFM/8dvwJzayJnrPALL1r59gYUUmyEx+k4SOnPqT0svMkpxWTJfwWwo9H3IU4ARe2SMyo1BjrOPyt87+5LPlPAR2MTMjo8oY4vAdL5m4m82dMHR9zQR16mSH2p9mouT4tokSZFCOpaG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlhWUY/2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlhWUY/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAA91F000E9;
	Thu, 25 Jun 2026 13:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393001;
	bh=ELu1XqzLLtw0ftMbKdrxxNGBOOFNd6jDIliOebKBKZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlhWUY/2j1Ktupx1hnG+QZdTJMS7HXyAKcCHlxRTLm6pCSItPHPFw0pVjd4QLR+Ad
	 BNA3sL6dAqb7SY2202eic/Rk2eBFsYQXSqkaAZuNiF0XohMdvQFd0UGvrFx9F/MZZn
	 CbihI4ucNlhBnFcu9MgLwMbqmxYJvgm4/Ag+PXv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 19/49] rose: clear neighbour pointer after rose_neigh_put() in state machines
Date: Thu, 25 Jun 2026 14:03:31 +0100
Message-ID: <20260625125640.175730670@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


