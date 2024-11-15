Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E6A14EC77;
	Fri, 15 Nov 2024 06:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653654; cv=none; b=GwrIlwwhXpaRvzscnT1nG0BOtngxb0N1h7u6L26TAZYyYMIaWuF9Pb4aFdEGwct5fotAPTDfIVSV0vkLcyQQ82AsJsY3x9ejxRrRBZUotokRSxkviHLKxhasG4rnBl2VIP8O7QMJmQLz/w2TDRZPYPGNEfkF/CHOuXIJnt7dwms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653654; c=relaxed/simple;
	bh=H5YW22/ZRxJvQIFmsV//dXRWeTy8T0wMEqDJltULYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ax40BgjjKtyGIE/xtJRKSzX7EvLyvNm5rUjMaPAabvSXt9cULZFI2VuIYCOkxAUv67fXhyRWotViEUeRj0zRx3/6RbJUCpmLvK3Y5sw5RwQoqMp/P271WsACbaWAa5XR8xVqqvIE6e1CqDSKks0SBI4toXJXEs1NPYiCNZ2q2uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwldn6UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwldn6UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC75C4CECF;
	Fri, 15 Nov 2024 06:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653654;
	bh=H5YW22/ZRxJvQIFmsV//dXRWeTy8T0wMEqDJltULYyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gwldn6UCmILnnDP+Qo+OOx8uugd/RqKkO5BwBN9J7FmPTCTmjKeiEDsBY84Jhmw+D
	 kpU+qSrK+HDJulbElcsANA8dFTWoTGqdIeET7jl23O25jxyI92dhwku3XDgFBHIdtN
	 LEW1+mMOl198uFQgsFQy7zyKhQy7uRqVV4Xfqa+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9af29acd8f27fbce94bc@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1 38/39] fs/ntfs3: Fix general protection fault in run_is_mapped_full
Date: Fri, 15 Nov 2024 07:38:48 +0100
Message-ID: <20241115063723.980833158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit a33fb016e49e37aafab18dc3c8314d6399cb4727 upstream.

Fixed deleating of a non-resident attribute in ntfs_create_inode()
rollback.

Reported-by: syzbot+9af29acd8f27fbce94bc@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1646,6 +1646,15 @@ out7:
 			  le16_to_cpu(new_de->key_size), sbi);
 	/* ni_unlock(dir_ni); will be called later. */
 out6:
+	attr = ni_find_attr(ni, NULL, NULL, ATTR_EA, NULL, 0, NULL, NULL);
+	if (attr && attr->non_res) {
+		/* Delete ATTR_EA, if non-resident. */
+		struct runs_tree run;
+		run_init(&run);
+		attr_set_size(ni, ATTR_EA, NULL, 0, &run, 0, NULL, false, NULL);
+		run_close(&run);
+	}
+
 	if (rp_inserted)
 		ntfs_remove_reparse(sbi, IO_REPARSE_TAG_SYMLINK, &new_de->ref);
 


