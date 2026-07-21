Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B46D43C7B5;
	Tue, 21 Jul 2026 21:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670215; cv=none; b=NPymPqSxWsFycwylyarMl/XtMx5VJiH3a+HCxiV22k93l4BGDSCvyq+JFM6pI+U8ngXKvR3+nTc//TJSdcDehoIJSndz11GTKFhv92uCQ61NyRSr4/7QwI04/9uBPShNqFozh7DRMANHZ4rvALnrUrIRTCGm+kcYMthMuD6yakM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670215; c=relaxed/simple;
	bh=MQQmcs51h01S99t+I3tD5Hty3ZaVv0eR41FO/decHsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVMApSqQMJjHrTArVaeCPIZvscssX3UDLgb5Tc/XQeCTjBzvRdA+wAYR5pBYmpEHRVtXOrD1LPjQvz6nCe7GHeaB2FoTkFMLeAy6eVJOOqRzWbD2/fH7HesmY6G+VN6lt/exUaXK4Cko/tZX0hZYOh52YAkhL06dDxbmfU5APdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mf/C2E27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mf/C2E27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C091F000E9;
	Tue, 21 Jul 2026 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670214;
	bh=ZSJIZT5602pFZ41Pk4XCAkn0H0E6phDN3ph9zW5GOF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mf/C2E27ItylZxHsGrMrGpDs/8kuCxVDqOOEIZTOAPpeISsRLUMfyiL8bf+HdsmRx
	 c/mwbdOsEv51zVS/1eqZvrMJo00/tLDiOu9/DXJWvEwTWfpRV+ct5gv9uMnyQ+ZbWS
	 +GxdrD5r/AVk8VTiFPz911b5r16gDBSITmsn1vkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0849/1067] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:24:10 +0200
Message-ID: <20260721152443.538312188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 366665416f20527ff7cad548a32d1ddf23195740 upstream.

If dm_resume fails, the kernel attempts to free table with
dm_table_destroy, but the table was already instantiated with
dm_swap_table. This commit skips the call to dm_table_destroy in this
case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2278,7 +2278,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


