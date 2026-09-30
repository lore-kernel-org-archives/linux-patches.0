Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9138F52BE47;
	Wed, 30 Sep 2026 17:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790521; cv=none; b=CN5u/c+gr/M1L7kl2IngW9Gb1nk/602chkyOA1rj+wmfgX8WgTNwiIFA8dNEcSMJ7ApvTaRK2F7VJyIKBdBXwFdaAsjzUowlfZYcSsO2IaNOyVHcLkANYOb+zudMlFITtrA2juXVukAi72PEQTZQ+/Uhr54LehTZDRE+qmfMSbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790521; c=relaxed/simple;
	bh=hYQk+aIpBdhPw9vCjoUU6b714hqoqpe19l6O+mcRsN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+7NaCqoCYipEKa+Khvji1YH52U16xOKYWaY5i6rhBG7f0qCb7xdYOlBIOoQ5wqORWCxsVeHEvtnaN1CUPkGw0FDRUqKCI4h0oh8RG3H3WvOy+JShSgIMziNP/IFAsVp3BNlXBDatSxdUnHsapXXLaDtd+17Oekx9lyylzDXoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQH1nTmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQH1nTmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F1B1F000FF;
	Wed, 30 Sep 2026 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790520;
	bh=8BZRqEdlVrkm7BkxrE6ULG6cEnnRSizKKpi/v3NPdos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQH1nTmA0urrBdqbiqE+0Mtznp9NsE8cuzSJ32N9uwuuRgQG12N3EUSvMj5IBLqtM
	 gj7T86MR41O6FWMUDjXA8vdj7dXhSOyIqAavM5cnyA5o9vmVRqvXkiTZjQ/INBwcJP
	 clGze94G4GnxENt3JfnS5OhOKFwqPEcOP6K5/V2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 857/877] rose: clear neighbour pointer after rose_neigh_put() in state machines
Date: Wed, 30 Sep 2026 17:29:28 +0200
Message-ID: <20260930152433.233143746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,6 +124,7 @@ static int rose_state3_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	case ROSE_RR:
@@ -234,6 +238,7 @@ static int rose_state4_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose->neighbour);
+		rose->neighbour = NULL;
 		break;
 
 	default:
@@ -254,6 +259,7 @@ static int rose_state5_machine(struct so
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
 		rose_neigh_put(rose_sk(sk)->neighbour);
+		rose_sk(sk)->neighbour = NULL;
 	}
 
 	return 0;


