Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F973126C0;
	Thu, 27 Nov 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255497; cv=none; b=pSco4AjtsNtJVqZjhHRf9OiSV45LWKj+fisd2c3Vl7Wxat379VDkNq0U7fcduGw3ptJEoIrV+UntNI1/ygXBdm0X5nNqiDF9v1bM/GS14EQJaTW8TNBfijjj5FGUZ99i5Ro3rScHRisea6H0KCRKX664jPpxq5iIx9kLZX4GDzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255497; c=relaxed/simple;
	bh=iL9J7ssQC1e6Af6n00n9u40DbQCn+jWUyMRe1xpM4Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxmrFYAdMBk1kn0kQMDJLxHODcIBPI8s7CnhLflHSyLzyI58+jzlvXoQ7FMauF+xLpDPhmkU06pjBPrH0IVmOAJs4BfdtrbdQKgGpI8oDorgFgOjokqpW2sopfDs34XL/AtLScXz4tQYxH1UQVHrCVfhipdNwiQVkaXTJwHbY6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2icKk8KB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2icKk8KB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC503C4CEF8;
	Thu, 27 Nov 2025 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255497;
	bh=iL9J7ssQC1e6Af6n00n9u40DbQCn+jWUyMRe1xpM4Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2icKk8KB/Tih5HOm9yZk4krKtpTi7Wb5prWFeBjgSbDts42Au3Vjqj7dOL+2Ne5AN
	 AKBtwF/2uvGPDwa57Gp5faOTnP1GPfmmnTHXynuDXRf3wzkOcTexg+OYtrVK5CLBAb
	 iIA6tHUU16PLJECOSVqC0P4vv9O4/y7vRZARDu5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 014/175] fs: Fix uninitialized offp in statmount_string()
Date: Thu, 27 Nov 2025 15:44:27 +0100
Message-ID: <20251127144043.477578199@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

commit 0778ac7df5137d5041783fadfc201f8fd55a1d9b upstream.

In statmount_string(), most flags assign an output offset pointer (offp)
which is later updated with the string offset. However, the
STATMOUNT_MNT_UIDMAP and STATMOUNT_MNT_GIDMAP cases directly set the
struct fields instead of using offp. This leaves offp uninitialized,
leading to a possible uninitialized dereference when *offp is updated.

Fix it by assigning offp for UIDMAP and GIDMAP as well, keeping the code
path consistent.

Fixes: 37c4a9590e1e ("statmount: allow to retrieve idmappings")
Fixes: e52e97f09fb6 ("statmount: let unset strings be empty")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Link: https://patch.msgid.link/20251013114151.664341-1-zhen.ni@easystack.cn
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5601,11 +5601,11 @@ static int statmount_string(struct kstat
 		ret = statmount_sb_source(s, seq);
 		break;
 	case STATMOUNT_MNT_UIDMAP:
-		sm->mnt_uidmap = start;
+		offp = &sm->mnt_uidmap;
 		ret = statmount_mnt_uidmap(s, seq);
 		break;
 	case STATMOUNT_MNT_GIDMAP:
-		sm->mnt_gidmap = start;
+		offp = &sm->mnt_gidmap;
 		ret = statmount_mnt_gidmap(s, seq);
 		break;
 	default:


