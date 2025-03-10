Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D102F190072;
	Mon, 10 Mar 2025 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628575; cv=none; b=Q3GW8+Ecz4rQ1fW+qFFAWp7HYlTki2GfcpniiXJ4onsyC9/nCz2uE4Ur9afT1j/sKySgYMvZs2K9zvC+9/VnCf/SkGvUx/Ix4bMFbz098LRJIxeJCMdODtOwK1sAbsX1mV11X6aNrZeQoMW+N9+NcATVW0mOp20m1hiVkXEBe2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628575; c=relaxed/simple;
	bh=z24/pwxPOEsbL2G7MKKrcpL3wRYAMyc+Vm6Fch7PGUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWXC1qUJn8e8lpg/iNJcM19nzAZIBuwD4Fzl4pGAnHqc3cLYZwCYpgYwO4bsenaCFMUB5dnAqvBmy4tV4PrSJCoZ9gWqwLViySQcU8fH0HZqlcWjDimvcRciaxGe+11eb+4Es3E9ct70doYEnLo5zcPwkmyhDtMhOhuh8JcYHeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsxTT//O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsxTT//O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97EDC4CEE5;
	Mon, 10 Mar 2025 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628575;
	bh=z24/pwxPOEsbL2G7MKKrcpL3wRYAMyc+Vm6Fch7PGUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsxTT//OtysiaiftafNhMMJ1O/jKpg8TgEQiIVYYU81VhsVRRJxdeSpX72XXHS0PL
	 /lYLWNUQSu8Lt0krdNfPGUlIgbDJT53FpCBsX8gwCLY6ln9FzYF0vS58bAhIfJlYgR
	 uzstXpopxcrINkn+0BaNwLP9ubMwy8r8vp73xwaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c6d94bedd910a8216d25@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 105/109] fs/ntfs3: Add rough attr alloc_size check
Date: Mon, 10 Mar 2025 18:07:29 +0100
Message-ID: <20250310170431.734296678@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit c4a8ba334262e9a5c158d618a4820e1b9c12495c upstream.

Reported-by: syzbot+c6d94bedd910a8216d25@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/record.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -325,6 +325,9 @@ struct ATTRIB *mi_enum_attr(struct mft_i
 	} else {
 		if (attr->nres.c_unit)
 			return NULL;
+
+		if (alloc_size > mi->sbi->volume.size)
+			return NULL;
 	}
 
 	return attr;


