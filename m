Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBE243CE53;
	Mon, 17 Aug 2026 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974989; cv=none; b=eFh92UoGFAqqDUifMPaaCFQr3+aGbSfa/bdDRm5DNNwyOJ3dH6ijNK4zBlqrGPy9spXN05H6roI0/p2gbSS8rxRGCHdcfNGKtDz7jKuc20lAHVamhZQjokAkZi7l7/XKkIBNcyLfcmPVDsK7hkXkgxniDgIP6SDUKQYisROQ5Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974989; c=relaxed/simple;
	bh=KaQgY15sos+qhxgaxh2s1q3pqbRan2VEuw2nJGtOeEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXVh6yeqItaLYMvaa0U+HDdsAKmOvmlkmsyXfHqkST4K6T3x2TfIIEiJseXb79lmIacM0Ixiqxxmjf4Crf1pnqs4XqlrX5bd6ee/n0l4rrKLaNzWk6QlxIaZergdMleIWjwgpmBpp1nDrJ1BV52wWiB6EaW+/qlm/dfeRYSzcss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZkbCNbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZkbCNbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF791F00A3D;
	Mon, 17 Aug 2026 13:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974984;
	bh=+jdOREpkF0a7JStT06oop0xW2zspHBDGEHu5yi6f/cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZkbCNbdPWink7h9WXkNIAFoFpaHV+XoAmUzxzdCt0dLHbgWI/3mVZfjCRyxyY+ga
	 fWEVddOF6RK1YCxkwVq4AoUpgK5CdX9KHpxc/gqwBk0e0ZuaF5yjHX20hoGmRLRmOY
	 IWncS29vS0ltedhFrqqwvjPuUNppqO6SnABS01Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>
Subject: [PATCH 6.18 123/250] vt: add permission check for KDSKBMETA ioctl
Date: Mon, 17 Aug 2026 15:31:24 +0200
Message-ID: <20260817132541.624449808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
@@ -406,6 +406,8 @@ static int vt_k_ioctl(struct tty_struct
 	/* this could be folded into KDSKBMODE, but for compatibility
 	   reasons it is not so easy to fold KDGKBMETA into KDGKBMODE */
 	case KDSKBMETA:
+		if (!perm)
+			return -EPERM;
 		return vt_do_kdskbmeta(console, arg);
 
 	case KDGKBMETA:


