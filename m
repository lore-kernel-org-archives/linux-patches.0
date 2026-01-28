Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A7A285C8D;
	Wed, 28 Jan 2026 16:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616052; cv=none; b=kH3wEvdi0lNTGerv6eEiiGs6wVSpowi2JFifJMnjCfppugpcANHqC4DAfRj3esS+WuVqp2a6cP1yyhttsC8cmxif3Da6djLszKlfRoJEkhmut3K7uZPdZJoaPQZ7DNCnU5wcvDqY/SXH0raIi8w11UPFpGN70ifDxrIDyNhc5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616052; c=relaxed/simple;
	bh=TAuLyX/6ti6bmYtOmDIBse4M6jXUWTevMU6X2p9IyR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gi8sclDXz2vd6A1jwCDD6i76GyRD01iNWesElYiWEmg+S7lUl15sPTdEQkMZHiY6GcfvEnUSsqhn9QqfJWfQxq5oDUNM62noxdZyVISqUGzfkDc2j3kznMyoSiXj/71OgcrMwjTa8TUXnLm7VBrJDrhoqLFsMDDCdGOvyYbxB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEqBW7Nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEqBW7Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4F5C4CEF1;
	Wed, 28 Jan 2026 16:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616052;
	bh=TAuLyX/6ti6bmYtOmDIBse4M6jXUWTevMU6X2p9IyR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEqBW7NjS5Kv684PYeJ+7w/DIYlu03OS9oaCRuMYFrS+fTfIb6r8bYcF7q67UFoOx
	 NrMUwLqQFa1DySB37cL/6GitgZIKdVpg+rUmUOrSzlQqRm3KEwyCYxHahqBw5olItV
	 XnGrtDAxpDKBIsUbbCYiBSoWiCpG0scsHnE+P+6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.18 192/227] uacce: fix isolate sysfs check condition
Date: Wed, 28 Jan 2026 16:23:57 +0100
Message-ID: <20260128145351.356363276@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Chenghai Huang <huangchenghai2@huawei.com>

commit 98eec349259b1fd876f350b1c600403bcef8f85d upstream.

uacce supports the device isolation feature. If the driver
implements the isolate_err_threshold_read and
isolate_err_threshold_write callback functions, uacce will create
sysfs files now. Users can read and configure the isolation policy
through sysfs. Currently, sysfs files are created as long as either
isolate_err_threshold_read or isolate_err_threshold_write callback
functions are present.

However, accessing a non-existent callback function may cause the
system to crash. Therefore, intercept the creation of sysfs if
neither read nor write exists; create sysfs if either is supported,
but intercept unsupported operations at the call site.

Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
Cc: stable@vger.kernel.org
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://patch.msgid.link/20251202061256.4158641-3-huangchenghai2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/uacce/uacce.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -382,6 +382,9 @@ static ssize_t isolate_strategy_show(str
 	struct uacce_device *uacce = to_uacce_device(dev);
 	u32 val;
 
+	if (!uacce->ops->isolate_err_threshold_read)
+		return -ENOENT;
+
 	val = uacce->ops->isolate_err_threshold_read(uacce);
 
 	return sysfs_emit(buf, "%u\n", val);
@@ -394,6 +397,9 @@ static ssize_t isolate_strategy_store(st
 	unsigned long val;
 	int ret;
 
+	if (!uacce->ops->isolate_err_threshold_write)
+		return -ENOENT;
+
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 


