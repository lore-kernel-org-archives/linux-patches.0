Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C80A3ABD99;
	Mon, 17 Aug 2026 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977691; cv=none; b=AkuOD3Pk8oV0YaPZZaZw4cBDje/DjVOtehcQImmemdQl4S3gq2Ct7Ia1i5zuENL8SOXsP3Z2A4YA0cgURMr0E802mMzKYe3YcQTmAxDv91iu100ViTQBHpsKPzQFQMUlJt07rRji6vk+A83jKICcwsKIQFapEY9s1X0znueB338=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977691; c=relaxed/simple;
	bh=cBesYS31Z4h91Uvt2D1Lmrwbg42ChBF0zZSEy4hTiQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F09DSSYVgiZ+UZOjaEPB36z4dclnB3l+I2JKMFgJplULh190iwjXdrsmwCM59h9ccR2h52bRLI/6hHAndrtoKwEbStdklxwNE0eZHASizPG3CWwuAr95v1br6AlvSBv9tZNxE3adaFiHjzohKFNPx0PyV12QRs84BrHd4agRxgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYrCVPjf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYrCVPjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E141F000E9;
	Mon, 17 Aug 2026 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977690;
	bh=1Hmv6KarqGoq1O3ZjZwwEE/d0wertsP9ZZckfruRYbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYrCVPjfZ2ihyJgTQN0e2nFHmP125On0Klb9EPPoqiw+mjI7kzk8+Fa8LMbQ/53vs
	 TRZJusjzscDjzeRjWhCzxmokGxYrZw8bZZDtq64F7BuNeM++zo7sq86DYJnvUbLpBE
	 VbrrS+tAfmk23hGr9sVSBKUIrV1bMQzTsTyY1T08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 5.15 416/456] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:33:26 +0200
Message-ID: <20260817132555.498494522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


