Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D034B1F7063;
	Tue,  3 Dec 2024 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239832; cv=none; b=KbWu7wVC8Z1nQ9pscBsLmrPbq9NTtA781eYADlVkiGRl7fU17HRLyR2CiKvkXuG+EvJ2/BaXx/z3JpPA7iVSvhtKZB61gj9sSNd6wFcm7+RPNoGHBqaAVOVGypeCHAZ8i7O1p2JAi3eeMaZN7bfWe7gWRK4tb5llBo2+hTBMkKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239832; c=relaxed/simple;
	bh=U8fq+hrXXRHATPx9t/01kE4rdOys1u9TSx7MuUoPErc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo3ZhBxBtPo8aDSsGdO619JncxVSbFr6N4ZV+KnM0SluOfvE0IPHa9XUAouTOPftBzrVMuaV78PFbh/vzkNIrvkl5kcLhEjjfymOOi2Xj68hAOoRzPFZGEU5czN6Xht5iPewcjxeYqkJoaW10YTk4BjNE4B8Zw06pKjKMDbZ6fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhMdtyGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhMdtyGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F5C4CED6;
	Tue,  3 Dec 2024 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239832;
	bh=U8fq+hrXXRHATPx9t/01kE4rdOys1u9TSx7MuUoPErc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhMdtyGWGoOX67ePNoaDhtyiGPiD08mysPHxKOX3h6+Oyc+eKkzzTPIiseqVBe8hz
	 gpVuYy6WErIkOzL951vS/nnS+8h3f/c2uDnHVhnJKdis0uikd2cwdqBG3HP68Oy91k
	 DYyUwN+2/RfubC7ip2/PMtnxEXAv/qGeRq5UvFbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.11 718/817] mtd: ubi: fix unreleased fwnode_handle in find_volume_fwnode()
Date: Tue,  3 Dec 2024 15:44:50 +0100
Message-ID: <20241203144024.018614772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


