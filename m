Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086472D0C63;
	Thu, 25 Jun 2026 13:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392771; cv=none; b=SwkVBkDSwkIRsxlskNeCdnAzhzNN7FbB3GXgUkymPEqDDLugTU/eCWRyQfF14dk30862pwlTd6TTU2axWM3vOpSZFeWXzlc4xioP9JImNhd8tCKDjM2eLeexIDyI86WDQwRXlCD02B7agGyEZ76szkyfg04UOUXTmGQZ/65fl+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392771; c=relaxed/simple;
	bh=QPZ25sqpTcU0ILu+uHoS909k/uCOploOG/bxrnT3oJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrK+8cyIDgSoVCijL9mOCG6+GV4ODMSG5T794tMS4GzSlp9lJe7t51VnzcyLYUQ68bM3cQEne9+RDlc5h5CrG3/uS3PyszgeeFRaDW04JO3TIp3KBdGVI4VSUiZ1gfSk43Id7kZGyM2D7FBoneAPqwfwCBDGtyixpFTeRSpvQFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEMFyUJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEMFyUJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE521F00A3A;
	Thu, 25 Jun 2026 13:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392769;
	bh=i8UodB0R8jf/RduQxUpKolVxlHpW//joEYq3gZsjxxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEMFyUJv5vXg1lZp6f+p6XIGK6tcsPP6C7DrIxxWC2Y/sc3p7kPVyztngntuoBlSA
	 jB1NPJIUd1ueFOmjqGwEzhOvBHFyg7Svo9nEivYp9BLMR/9ZU7voZgsb7CYqkjoDjM
	 CpyUEjFIFk79oFgZXWMgeHqS60l4kJoY9lhq+fBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 18/60] rose: guard rose_neigh_put() against NULL in timer expiry
Date: Thu, 25 Jun 2026 14:03:03 +0100
Message-ID: <20260625125648.217028515@linuxfoundation.org>
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

commit 2b67342c6ff899a0b83359517146a5b7b243af97 upstream.

In rose_timer_expiry(), the ROSE_STATE_2 branch calls
rose_neigh_put(rose->neighbour) without first checking whether the
pointer is NULL.  After commit 5de7665e0a07 ("net: rose: fix timer
races against user threads") the timer is re-armed when the socket is
owned by a user thread; between the re-arm and the next firing, a
device-down event or concurrent teardown via rose_kill_by_device() can
set rose->neighbour to NULL, leading to a NULL-pointer dereference
inside rose_neigh_put().

Add a NULL check before the put and clear the pointer afterwards.

Fixes: 5de7665e0a07 ("net: rose: fix timer races against user threads")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_timer.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -180,7 +180,10 @@ static void rose_timer_expiry(struct tim
 		break;
 
 	case ROSE_STATE_2:	/* T3 */
-		rose_neigh_put(rose->neighbour);
+		if (rose->neighbour) {
+			rose_neigh_put(rose->neighbour);
+			rose->neighbour = NULL;
+		}
 		rose_disconnect(sk, ETIMEDOUT, -1, -1);
 		break;
 


