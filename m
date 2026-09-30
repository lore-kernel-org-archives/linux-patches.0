Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C034851AED4;
	Wed, 30 Sep 2026 18:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793836; cv=none; b=D7dyX0VOUbqwMCMth1HOUlM56txO6G2bfRSnZ7NWrMmdlR3H3HwBcLjvPd9+fYYXVCWMKJBxkGwmG2JMqANfhKH7zkk+mAkgq8o79oMNTV96W8BLsJB25r6sY6UEFKFSMis35qVJMOEqKmZQxhFFQPECQ6J70XB0HQpYpMCXxxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793836; c=relaxed/simple;
	bh=vQfoxWs9dTO2IzTmAYMijDimOL4Gv4ELAqf5AwV7BpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7N3yLaI9OwKRGNP+ShdCJjqz70k6oEXML+wcX5K3GhQ9ym+HvLoEtU6BuIMkA0DYtj2c+PndZIXgCrxnQ8on3bzmBBThvXurGxdAUh/VPWDsIUD7dbpszCTudD0F/T0THSMvAjlvmPIYRKpvrd5diWev2O67ZE/2l3IcnqPlxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GClXo+r1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GClXo+r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059851F000FF;
	Wed, 30 Sep 2026 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793835;
	bh=6akGJL3ymMO2QW8tJ+ihvYdpRmMdR7un9lR+rUQf7yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GClXo+r1KPVwF+n2OxWCvKF4Kvtnz8oO4ZXHg4UobFsc7xyLxokB+NSR/TDqMaUHm
	 SUp970aF26+DcqepKzohSIfJU0gMBEYrR4+/IHTddX54LbdOdUA1OW5zZGa0/uNXhS
	 MATkfI7Nc2rN3BGxhHzCAzZDnFPw0thWQGUVfSIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 394/395] rose: dont warn on stray CALL_ACCEPTED/CLEAR_CONFIRMATION in state 3
Date: Wed, 30 Sep 2026 17:30:56 +0200
Message-ID: <20260930152349.249467142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

rose_state3_machine() logs "ROSE: unknown %02X in state 3" at
KERN_WARNING for any frame type it does not handle during data
transfer. Two of them reach that default arm routinely on real AX.25
links and alarm sysops watching the console, even though they are
harmless:

  - CALL_ACCEPTED (0x0F): a late or duplicated Call Accepted that
    arrives after the socket has already moved to STATE_3, typically a
    retransmission on a slow link.

  - CLEAR_CONFIRMATION (0x17): crossed clearing, or a clear confirmation
    left over from a previous incarnation of a reused logical channel.

In both cases the frame is simply dropped: no state change, no
teardown, nothing freed. Only the noise is a problem.

Drop these two frame types silently. Keep reporting any other,
genuinely unexpected frame type, but through net_warn_ratelimited() so
a misbehaving peer cannot flood the kernel log.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/rose_in.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -203,7 +203,18 @@ static int rose_state3_machine(struct so
 		break;
 
 	default:
-		printk(KERN_WARNING "ROSE: unknown %02X in state 3\n", frametype);
+		/*
+		 * CALL_ACCEPTED (0x0F) and CLEAR_CONFIRMATION (0x17) may show
+		 * up in state 3 as a late or duplicated Call Accepted, or as
+		 * crossed clearing / a reused logical channel on a slow AX.25
+		 * link. These are harmless protocol races, so drop them
+		 * silently. Any other frame type is genuinely unexpected and
+		 * is still reported, rate limited to avoid flooding the log.
+		 */
+		if (frametype != ROSE_CALL_ACCEPTED &&
+		    frametype != ROSE_CLEAR_CONFIRMATION)
+			net_warn_ratelimited("ROSE: unknown %02X in state 3\n",
+					     frametype);
 		break;
 	}
 


