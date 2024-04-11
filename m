Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590311465BE;
	Thu, 11 Apr 2024 10:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832073; cv=none; b=SYftN2SdLk6fGgebiACP/E9u+yYH+rAva6bNMoJVd306E7PQRliimh7m1iB7Of8T5VhDIeh3ZIHPTDQT8KSlxcYVE2cBI4aV26KwUC6zdJeVKZ6JtQQey9vZDG1D+ncupZoXIPShiKKg2uvISNRa4ziMuSsql+Cdcj4nWVQw+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832073; c=relaxed/simple;
	bh=vOUB4b8QvhPRVfiziry1Vb4LfXx4UnjXkuhRFKOTUpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiQ3mrUAMdNwmWhVg9jp2NeknP6kUdPBQ50nbKPRzPUk2rt1JlpWXYgrvKRPdOcLrX5IopvHX+3Wz2+W9jF8zvBFU9MQn6lpIk/qAFwCree9eS3Uh+IyBVnHKqCqMJzmYO2dQahZs8MkljYRIxdhnMJxfJd9c56zK7hmye7uu9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjbjGQNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjbjGQNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9406EC43390;
	Thu, 11 Apr 2024 10:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832073;
	bh=vOUB4b8QvhPRVfiziry1Vb4LfXx4UnjXkuhRFKOTUpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjbjGQNsvxsiiPhgLsGtAN5R3jLMpBs5hXfsVTGDQyL/AbPtYja8OpuBETStFJOcP
	 rdXJcquo7e38usAo/qwGsEdxly9mpKPT4AUgBO/g1O4WiitWtNAXPBI+y0mR2UuOSe
	 t1XONHHvCKZfNoIzXkmzp8+Tb0nIBUDMpenwuL6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 219/294] i40e: fix i40e_count_filters() to count only active/new filters
Date: Thu, 11 Apr 2024 11:56:22 +0200
Message-ID: <20240411095442.188071870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

commit eb58c598ce45b7e787568fe27016260417c3d807 upstream.

The bug usually affects untrusted VFs, because they are limited to 18 MACs,
it affects them badly, not letting to create MAC all filters.
Not stable to reproduce, it happens when VF user creates MAC filters
when other MACVLAN operations are happened in parallel.
But consequence is that VF can't receive desired traffic.

Fix counter to be bumped only for new or active filters.

Fixes: 621650cabee5 ("i40e: Refactoring VF MAC filters counting to make more reliable")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1230,8 +1230,11 @@ int i40e_count_filters(struct i40e_vsi *
 	int bkt;
 	int cnt = 0;
 
-	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist)
-		++cnt;
+	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
+		if (f->state == I40E_FILTER_NEW ||
+		    f->state == I40E_FILTER_ACTIVE)
+			++cnt;
+	}
 
 	return cnt;
 }


