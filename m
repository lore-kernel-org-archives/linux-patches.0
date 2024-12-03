Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E881EE00B;
	Tue,  3 Dec 2024 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242539; cv=none; b=hok9vPqu6yN5cVQFM8Nvd+3+jpvhQ5rrKX5rjNFzyOM9jhTfsauMBq9DyoJcC7nlXUS5/zM9sx893G2ynMeDKwvSvi46GbpShKBIuFsgvowxXLKtMLXgmWBUasp9KpaRt8/4Wts3qm6DXQwXMLL90Vu05waMuZxD42ot9ts7f34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242539; c=relaxed/simple;
	bh=wITLZtuH9JBrKuEgJLLYzsHA5vI3faEu6PRQQTAK+SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmnbCdYytZwxTucz6ZL59SDn5BmbrTZYcWoQrS2GPHg4Sig9qw/kp2xDkuCfn3jaO9hGj324uR17F+DcU6jL3LswQpnteKl+oKPovvERlVIIibesnfjlYL789Va146gWtmIFJq+4uxmRoV5QDSeCDJfS799i2P3cEWmwm/p2N8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGtnGiQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGtnGiQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F72DC4CECF;
	Tue,  3 Dec 2024 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242539;
	bh=wITLZtuH9JBrKuEgJLLYzsHA5vI3faEu6PRQQTAK+SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGtnGiQXCFgU9F+NaN7IcSQTC/CRhNpSXJDqq6hMfiU0ByYe5Xd3vOXeju/T1jgRQ
	 7YBNgUheNuUFl7Lhh4UNuvSc4nNiDwGbzsw9qzuM0dmNNcCOOn+np+58aTxjknpQS6
	 v0DAzdknC9uGEbKKgbZyWSHnfK0o9ZfxFzX4lCX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.12 717/826] mtd: ubi: fix unreleased fwnode_handle in find_volume_fwnode()
Date: Tue,  3 Dec 2024 15:47:24 +0100
Message-ID: <20241203144811.731922825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 07593293ffabba14125c8998525adde5a832bfa3 upstream.

The 'fw_vols' fwnode_handle initialized via
device_get_named_child_node() requires explicit calls to
fwnode_handle_put() when the variable is no longer required.

Add the missing calls to fwnode_handle_put() before the function
returns.

Cc: stable@vger.kernel.org
Fixes: 51932f9fc487 ("mtd: ubi: populate ubi volume fwnode")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/vmt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -143,8 +143,10 @@ static struct fwnode_handle *find_volume
 		    vol->vol_id != volid)
 			continue;
 
+		fwnode_handle_put(fw_vols);
 		return fw_vol;
 	}
+	fwnode_handle_put(fw_vols);
 
 	return NULL;
 }


