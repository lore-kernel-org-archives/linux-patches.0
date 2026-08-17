Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDC0436361;
	Mon, 17 Aug 2026 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978540; cv=none; b=VkyJx6oEGwqMDTpGxgQ9VJ0TTrZvPPWfxk4apgygPw2/m2b1V3Krba6t7qQftDxQ8xOY3bukGj/aZiDJj0detD1X9DtH3gg4j1ZpzLOdFhULzdhDsicMhHikWLq6maEL9ETfaYSEh2rM6p+t3KPd7K+Gn/8Cbsc2/sHUypjAX2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978540; c=relaxed/simple;
	bh=cgzKjjVu8zr41nIlw5CNOwFVhVxS1v5JqEU6nyPHNMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oENnqK/LO0hJSyyxgsDi3qf5W9BReKaaTkrMrBTAUWg3b4m5LLxuKA0khpSf5dpiirg3/LxIcvU+UcIMlLj3s4YS5zK/ocwjBHm+AdYvgEvaVKBT8OX3ILfB1Oo9K8Gh4XKf73A/NRXAz7kMej/Jj4J+pDPqTV6zPTfZE87E5Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyX3nJ/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyX3nJ/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328A71F000E9;
	Mon, 17 Aug 2026 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978539;
	bh=pVyOdFcXj++K2I9AAsMAFAgaz74mbXO3tjjjF3yaGW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyX3nJ/AqNCoijF3mKEbqIcHMf6usMoqB8ZlduFNULGCC6kFp5Fwg4/Iih4EJF1vA
	 r2uKtLGdUJdcRcuoiQ9kN6v7K8ttsZyxKSXf7aFS8pkASflhfAc/GY122G4rYx/Sbp
	 LAX0UcFCEb8O9F9AfZlsQwbjL9iLvjUdh+6iwYNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 6.6 071/156] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:33:25 +0200
Message-ID: <20260817132537.366415602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


