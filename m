Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07C114535E;
	Thu, 13 Jun 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280011; cv=none; b=bker7zavoZ3BuxXUq3naKNBXy8GqWZwwud1LzF79zyZy7ruIcUxNQZ8/RQRD6M0//MpaIKvvN5VfZwqjMSxYvum/IGhU4/HROIfgrgF/MiJf7JbrMjM0xpWoalxn8q/ByuqrRQOFLVUz4VLYlm1AmWuou2SUrsr9/hrh9BTZk2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280011; c=relaxed/simple;
	bh=4T36Y1RBxruxdyh+mg6c/FRqaCWbQsmEnq3qcoeFqfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAOm/vMd4oUeQa3w9JN5jS9s//3Fk45gu7rKEiL5fraCSzwfEIk2jrBQZnfe+oVoK6QGXFJ7AWUL5/K/+lxlDZgdvUNs3GhDEdOHO+DG8aJtzV8nSAi9YT8gt0xPajMaI0A3PVYZWFW5/BtxcJfH654PH7IZ46IS1nxD67WgDEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urnhMY6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urnhMY6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47163C2BBFC;
	Thu, 13 Jun 2024 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280011;
	bh=4T36Y1RBxruxdyh+mg6c/FRqaCWbQsmEnq3qcoeFqfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urnhMY6szCtKsgA2+D4u3AXogClpDu5V4nyPmWxy0vIvrm5UoLuLORQ+MhRSAC0pB
	 Bu5OPNbM7lSZARMyYfZFG6vlNUpnzwtPg7RhawAuxnM8Br3Jg8T0VxFgrtA7f5/RGl
	 zsy0zeRlRRN6AHbuASYVA8AkRJLqiLtbnbnsQZv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/202] stm class: Fix a double free in stm_register_device()
Date: Thu, 13 Jun 2024 13:33:30 +0200
Message-ID: <20240613113232.083886226@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3df463865ba42b8f88a590326f4c9ea17a1ce459 ]

The put_device(&stm->dev) call will trigger stm_device_release() which
frees "stm" so the vfree(stm) on the next line is a double free.

Fixes: 389b6699a2aa ("stm class: Fix stm device initialization order")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/r/20240429130119.1518073-2-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/stm/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 603b83ac50852..1cfae56c4fdbd 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -878,8 +878,11 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
 		return -ENOMEM;
 
 	stm->major = register_chrdev(0, stm_data->name, &stm_fops);
-	if (stm->major < 0)
-		goto err_free;
+	if (stm->major < 0) {
+		err = stm->major;
+		vfree(stm);
+		return err;
+	}
 
 	device_initialize(&stm->dev);
 	stm->dev.devt = MKDEV(stm->major, 0);
@@ -923,10 +926,8 @@ int stm_register_device(struct device *parent, struct stm_data *stm_data,
 err_device:
 	unregister_chrdev(stm->major, stm_data->name);
 
-	/* matches device_initialize() above */
+	/* calls stm_device_release() */
 	put_device(&stm->dev);
-err_free:
-	vfree(stm);
 
 	return err;
 }
-- 
2.43.0



