Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6F325E818;
	Tue, 11 Mar 2025 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706924; cv=none; b=gjwevqiKXjY4PJ1nlKw79+rW5Agu2d2odq6yhb+itEDaZdKFQOwH9yV3pcKpPDA8gnuqPyp8EDLVvhR7f6rZ7Dvg92aCVwjr7P4sqoR1d3+a1BJWUo+z0BLGggag++ExgE+UtnvvH0T+epPOCVRVoFXVRBOAsC/Jvy4ICbHUBJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706924; c=relaxed/simple;
	bh=L/ZNNfJhdTPj4Vaom/Z4LEbgJj87bh6thpBvhF5Uo+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKVdCgg4dVVk6uxLSglVyUxY4hoPn1YlwRt2Dm0n9tDM7w1LBZlHOQfHKhUY8ynkV2PZjWrq272ybvxjCaquOxwo5YFdLWLnem19Bns6MAP7HuY02OynNg5RFvKTqm2CIqIL9BZiUCbDF1RV7Ia4pxazA0HTVzyEcmI38n2vlOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZkQfboQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZkQfboQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02589C4CEE9;
	Tue, 11 Mar 2025 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706924;
	bh=L/ZNNfJhdTPj4Vaom/Z4LEbgJj87bh6thpBvhF5Uo+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZkQfboQ3PKX1HSTSBmUfAs76zPeiF04TpDNlp1RteXni2Q9XxS08rPbxH48sUmOR
	 wMWfzQ/xnEAd/ynygLG74XmjE8b+LnWAcvCOJ4KFpsXrbbAL5tV09lMDlWdP8/Mypf
	 yMg3Rvm0CytHjujvn+DLgE0zfoNkrb5zXpiBpGmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 183/462] of: reserved-memory: Fix using wrong number of cells to get property alignment
Date: Tue, 11 Mar 2025 15:57:29 +0100
Message-ID: <20250311145805.583018869@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 267b21d0bef8e67dbe6c591c9991444e58237ec9 upstream.

According to DT spec, size of property 'alignment' is based on parent
node’s #size-cells property.

But __reserved_mem_alloc_size() wrongly uses @dt_root_addr_cells to get
the property obviously.

Fix by using @dt_root_size_cells instead of @dt_root_addr_cells.

Fixes: 3f0c82066448 ("drivers: of: add initialization code for dynamic reserved memory")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250109-of_core_fix-v4-9-db8a72415b8c@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -94,12 +94,12 @@ static int __init __reserved_mem_alloc_s
 
 	prop = of_get_flat_dt_prop(node, "alignment", &len);
 	if (prop) {
-		if (len != dt_root_addr_cells * sizeof(__be32)) {
+		if (len != dt_root_size_cells * sizeof(__be32)) {
 			pr_err("invalid alignment property in '%s' node.\n",
 				uname);
 			return -EINVAL;
 		}
-		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
+		align = dt_mem_next_cell(dt_root_size_cells, &prop);
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;


