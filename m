Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CE75172E2;
	Wed, 30 Sep 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790524; cv=none; b=ZAWoMPuOCub2+omKMIUJ9Pzfz3G3oG/K4Eb/uPgzuUyfrcJtQIt76BDhNyn85a0PHHh8NSZs6W+swFrAFZHkr8LKc8kfTetDN4x6GmsWh+kPXjlTXCWLUeXTweMdxQS0RqFQps2BSVM+c7rJjrb6oUPzFoM/YVdDe7+9W/cwadE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790524; c=relaxed/simple;
	bh=nHEX7I76mCjspyVEBUZimzqb8XScBtnlkSvxQquRNGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Anmh3t+q7Us/pPDUkNtCPgne0ODyaHXh9tQRQHAG/zESkoQ2dHXIFVo9e9G54GqDNfPpSdJxb7nI4/zY19ddfEgi728G1K0aAY++kUm0MssQ5hnpVzY26DGRTYIVFgu6bYx2vXWWv8CfvdlnHIxcXs6Kiw9/3KM2ZM8ozcI4Hjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf/h46eX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf/h46eX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD01D1F000FF;
	Wed, 30 Sep 2026 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790523;
	bh=OJn/0Zqy4xITWnGjngjc+4nAb5qrEeIH32TGqMhO+fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yf/h46eXlu7g/ZHDf0stx5jHbpZt1F/3qzh9FMfgSVOzcJQ6npUj8Dp+GqGcBnAFq
	 A1oPDFRSiGvtn4MMtN2217armRhMI77kD3Y36TcUbwgQQTsR8gKAh5TkignPA2cezw
	 iJjxjwi64p6TzroSOxvwzgP3k3M1KtH1FRYLtuY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 858/877] rose: guard rose_neigh_put() against NULL in timer expiry
Date: Wed, 30 Sep 2026 17:29:29 +0200
Message-ID: <20260930152433.254443958@linuxfoundation.org>
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
 


