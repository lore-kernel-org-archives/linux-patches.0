Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969544838E;
	Mon, 17 Aug 2026 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980355; cv=none; b=PKRrTCsPvNsuTXnJgzWyoEz7eJ0Bxxk3U/G8PZslcFv7HY95UIMsex2eBaZY9XfMC+sH0a4e/0Gqq0LE3BvGSrywk38iikz307PkTScKsNdqEpiQWZmxSzpEk09copwH0XWuUxscrYSpU0Zct/buq184ganc4hMLNRASl7zZA5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980355; c=relaxed/simple;
	bh=OPd8sGObJG9JQRICPWO3+I8iofDf6hbuGTJBnPxr9Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWBx17j1Mkzkn8w0VF1LYgfEOzaIpjXhVZqvHH7oHRvBIQlKAx2FEudgAMhAJH+xfJnsYEzhjENF8VarrGJMgDnz+qE/Nm4jtVHQSKKuSHYwLdJ4iV/uTEDWhWT0NI4x8IJH7n42APSph14Wt5XZS9zQxZfrUbacn8MgzyC4Vt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9KooB8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9KooB8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DE1F000E9;
	Mon, 17 Aug 2026 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980354;
	bh=uexKJfwFBQJly9IDT2hdQP/1AIb4bGxPWoPYiUCwWkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9KooB8SuboXdA7SQ1oK84WaimlKiZcJfYhMeSB88CFdDph9zRxLjXIOkET9cuA6F
	 uSmCwXJb/J3c+f0zwaywIe3cUTB+s0Ol3latPMqSBdkev1kh/W88W3vGJbMN22nJLF
	 H/UFyoqImwYgWZBDhAipRBiRiERx3n3ONYyQ1ag0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 6.1 545/609] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:34:01 +0200
Message-ID: <20260817132601.998619854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit a7ad0034453ba4c353f9b8f810ee2569de33d283 upstream.

KDSKBMETA modifies keyboard meta mode but lacks the !perm check that all
other keyboard setter ioctls in vt_k_ioctl() enforce, allowing a process
to change meta mode on a non-controlling console without authorization.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Link: https://patch.msgid.link/20260731-tty-vt-stuff-v1-2-be99b9da8e30@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -408,6 +408,8 @@ static int vt_k_ioctl(struct tty_struct
 	/* this could be folded into KDSKBMODE, but for compatibility
 	   reasons it is not so easy to fold KDGKBMETA into KDGKBMODE */
 	case KDSKBMETA:
+		if (!perm)
+			return -EPERM;
 		return vt_do_kdskbmeta(console, arg);
 
 	case KDGKBMETA:


