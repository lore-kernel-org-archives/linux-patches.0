Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1077346A1B;
	Tue, 26 Aug 2025 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214110; cv=none; b=q1+JxzcviDnoBVHiWLQcT7q3K/sEU4QMNyP0KV5uRTDBppe4HtNxQI3hLQTD9OX43tBbgvt1RXBi1eUG6jDAb/MfazzJKdeG7G3q+0PlhiVt05eMV0QzISNj36v0rvx+D9uHPa1VMbW2dKnk1/+8w/NdX/AH+szeKLmF7Lvudbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214110; c=relaxed/simple;
	bh=IGNLrsp4dffsed9+ngzkl5CQe5NuKMmGxznBeQ62Seo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHMLFRComPQ2I4GKgCptF8fOUYYMoIouH4J8k3Hwamfxnbr9KcsqdHhrSKf9EJ+r1CSjn1DcdACXDa208EJFrx1r1qLXFTBeAIn2+FhRM+ta2FzYj1An+RwzTtzax1Xol83/HNoIjhWZN6+sWsbvcNa6xE9xkUVps61ehFgrH64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZecnQxG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZecnQxG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2051EC4CEF1;
	Tue, 26 Aug 2025 13:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214110;
	bh=IGNLrsp4dffsed9+ngzkl5CQe5NuKMmGxznBeQ62Seo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZecnQxG5tUSJYyDomMzMOI1/uOjAlY5HELa8Bosc0OWwHRFO/I+j8EP91SeWf2nLm
	 8qgtnMhKIgzNULwNaC64ZXOGpPVirE+4HSXC4C+d1MwAfWSsWKtz6sqRcmXYk5L3ia
	 mG8B9bYvXgcio10cHbcfCZPVMKSSy+fiS6QrviWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 007/482] smb: client: remove redundant lstrp update in negotiate protocol
Date: Tue, 26 Aug 2025 13:04:20 +0200
Message-ID: <20250826110930.963404167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

commit e19d8dd694d261ac26adb2a26121a37c107c81ad upstream.

Commit 34331d7beed7 ("smb: client: fix first command failure during
re-negotiation") addressed a race condition by updating lstrp before
entering negotiate state. However, this approach may have some unintended
side effects.

The lstrp field is documented as "when we got last response from this
server", and updating it before actually receiving a server response
could potentially affect other mechanisms that rely on this timestamp.
For example, the SMB echo detection logic also uses lstrp as a reference
point. In scenarios with frequent user operations during reconnect states,
the repeated calls to cifs_negotiate_protocol() might continuously
update lstrp, which could interfere with the echo detection timing.

Additionally, commit 266b5d02e14f ("smb: client: fix race condition in
negotiate timeout by using more precise timing") introduced a dedicated
neg_start field specifically for tracking negotiate start time. This
provides a more precise solution for the original race condition while
preserving the intended semantics of lstrp.

Since the race condition is now properly handled by the neg_start
mechanism, the lstrp update in cifs_negotiate_protocol() is no longer
necessary and can be safely removed.

Fixes: 266b5d02e14f ("smb: client: fix race condition in negotiate timeout by using more precise timing")
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4217,7 +4217,6 @@ retry:
 		return 0;
 	}
 
-	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
 	server->neg_start = jiffies;
 	spin_unlock(&server->srv_lock);


