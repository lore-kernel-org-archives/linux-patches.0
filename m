Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A4B36D4F8;
	Tue, 16 Dec 2025 12:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887493; cv=none; b=YtTuqwe2OxnfdSlaJOj7z4pkzA97PctzNQYusZCz//15otedI7fmKmWEpaiRIbtgIigDPL6sO9jMFWk2Tlr2yVseejTWpO6kVBwaYNlHrWwDbSzwGQYN0JtfyQ3nRJldgBS7REPWUVCl+aoJmdXdHM7qj1/AyX5jA51AKIUq918=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887493; c=relaxed/simple;
	bh=IPlPEpWc1DdCAGP9Q8c6ySsOCjcoQccVixHP2SCFgMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blF2BnDy07DhcYX+UzKOZilK5defCMrsxEuGzl/wWzfxnDeNVCJ4cMkpCDOKMkPl9woZ0CBA0zRE1BdwUAjxKz1wgKDjQ225c9QpfHZjPxIQytXzlgIqQ8Ci/qJmh5lglkG6Is6ZKMjtfVeOU3ehHVupTCUw7ZgBetVXSeQ026c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amtdl5XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amtdl5XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC41C4CEF1;
	Tue, 16 Dec 2025 12:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887493;
	bh=IPlPEpWc1DdCAGP9Q8c6ySsOCjcoQccVixHP2SCFgMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amtdl5XUgsryNhcZjwUwksNZbRX6Dn6jh/bTzqSOAt3GLK1Al2M3BgpSaZjn0Ryrp
	 UGNoEue69XyXtZPAjT0m0kzsKebyCY+cVaMX4mmoKCr6oVF4fFPEf9ZTLw1RE/itM9
	 2yOkWmY4URdXM6jUY8u8FPVenEN3wZCF/XkBzgEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/614] scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()
Date: Tue, 16 Dec 2025 12:10:07 +0100
Message-ID: <20251216111410.063450573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit d794b499f948801f54d67ddbc34a6eac5a6d150a ]

The function ufshcd_read_string_desc() was duplicating memory starting
from the beginning of struct uc_string_id, which included the length and
type fields. As a result, the allocated buffer contained unwanted
metadata in addition to the string itself.

The correct behavior is to duplicate only the Unicode character array in
the structure. Update the code so that only the actual string content is
copied into the new buffer.

Fixes: 5f57704dbcfe ("scsi: ufs: Use kmemdup in ufshcd_read_string_desc()")
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Link: https://patch.msgid.link/20251107230518.4060231-3-beanhuo@iokpp.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6a060a724618..12f5a7a973128 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3837,7 +3837,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
+		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
-- 
2.51.0



