Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D5818FDB7;
	Tue, 10 Sep 2024 10:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962446; cv=none; b=oP5L3YzYbsMywkrvPXesQoFmj9PQgPjGdZFKrIjlebTfSV4Vhdm9pFL5diN0/yUWIN13v5naB9uTYj7uI4L7LbBgPX45amE9X2Ms4gIEZ1KNXi74cWj1W7O4XrQz5l9+7X4jdu+sIHMVv5HRwaestiF3e25CrRI4SrNG9vF8ALQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962446; c=relaxed/simple;
	bh=H3L/+09se/XgLSoPILaCkBh5hrRqJpJNyDf4GG/iqkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeTsNehJRKQ6MZZYVGBX3Neq9hAk8KfQc9J1SEFg10CJFn0Q+Qvprq4oRimHwJuLjReMUuSdNFhfls+hTxTUbJTN4pAkjV9Qaqw5D8JmI6HsPzlRaIfDc3c1rdY0Yr6CgyV8xJ0DL58ojDntWG3cJgLEaeswUKdnWGOSUZG2uCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIPQTCM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIPQTCM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269AEC4CEC3;
	Tue, 10 Sep 2024 10:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962445;
	bh=H3L/+09se/XgLSoPILaCkBh5hrRqJpJNyDf4GG/iqkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIPQTCM3DGJrrGX0ymadvYEFcb1hN6uJOrq2AB9xTwfJSkrNrFwIjllr01RYUObTz
	 6QFAyIxUQGIwZ1gpMCfc4SMbaAnq4lJ4DkOP5yRPH6lLv7moHpWAcsIFlO7/tpk8C/
	 uzXZ9ufS5xuzb0r7IpI9+lIirE3EkKWH9H7v2V5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.4 029/121] ata: libata: Fix memory leak for error path in ata_host_alloc()
Date: Tue, 10 Sep 2024 11:31:44 +0200
Message-ID: <20240910092547.118298534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

commit 284b75a3d83c7631586d98f6dede1d90f128f0db upstream.

In ata_host_alloc(), if devres_alloc() fails to allocate the device host
resource data pointer, the already allocated ata_host structure is not
freed before returning from the function. This results in a potential
memory leak.

Call kfree(host) before jumping to the error handling path to ensure
that the ata_host structure is properly freed if devres_alloc() fails.

Fixes: 2623c7a5f279 ("libata: add refcounting to ata_host")
Cc: stable@vger.kernel.org
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6203,8 +6203,10 @@ struct ata_host *ata_host_alloc(struct d
 	}
 
 	dr = devres_alloc(ata_devres_release, 0, GFP_KERNEL);
-	if (!dr)
+	if (!dr) {
+		kfree(host);
 		goto err_out;
+	}
 
 	devres_add(dev, dr);
 	dev_set_drvdata(dev, host);


