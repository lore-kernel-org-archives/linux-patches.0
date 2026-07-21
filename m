Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BDD415F1A;
	Tue, 21 Jul 2026 18:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660230; cv=none; b=EWyc99Zd0plH4uJJD0SngIjlQkT+8KTweVhbOldBa0lgoD7EVx9XEDrpd1lg3hV8DlFaCSKfAsvABf9r9hjQ/47xRfcF6dMhTpyDPdMfCqbGS8SBIQ45Tn4ebBb7DHAA3JBMKLEG8O+fumviGLDzv06W5rzcOW1QmG8JYYIhrMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660230; c=relaxed/simple;
	bh=ECTTYJ6le8zm21IwGczxoZp1NwPyoVh4uZxMzzTRmX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUD7gOKJCgA2UYCbYzl6CT6MCLIUR+Ude1b4rWelf3fKyv4r3JxhjGRyxKHjK2LhqLSnLdks5SChhZ7EB+nHpcYbogjhsBRAT+UZzl0LOZVE5kp7QmuCuEbYn/GI4vUaMo3JaIz8F3pDnjy6RGRLp/1NxpEcGUWfYZCI/wcruEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUHUCSVi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUHUCSVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB011F000E9;
	Tue, 21 Jul 2026 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660229;
	bh=ltKSjR/7ZiA2pYa1ZiUrUqw64o0ObNlQfJbumhA5V64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUHUCSViMGk0FS6vZpMlpC2K9r4hirsZFGJm5mXbGo3bqdn/04kTcl5oBVMFjNa80
	 MvvtzN65qRVykZXEASyqTU0b1NyJL6MUvNhLPjlb0YVS5rpfmbqj6bUPpIdjFqlfDa
	 figCcfSZUpKK+eJBPgDVdt0RCzWub+D891D/6m7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0874/2077] coresight: Fix source not disabled on idr_alloc_u32 failure
Date: Tue, 21 Jul 2026 17:09:07 +0200
Message-ID: <20260721152613.407937953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit ea2c2b9e2a66e2b4aa0455b2d70058e2f0ea4d23 ]

In coresight_enable_sysfs(), for non-CPU sources (SOFTWARE, TPDM,
OTHERS), the source device is enabled via coresight_enable_source_sysfs()
before idr_alloc_u32() maps the path. If idr_alloc_u32() fails, the
original code jumped directly to err_source, which only calls
coresight_disable_path() and coresight_release_path(). The source device
was left enabled with an incremented refcnt but no path tracked for it,
leaving the device in an inconsistent state.

Disable the source before jumping to err_source so the enable and path
operations are fully unwound.

Fixes: 5c0016d7b343 ("coresight: core: Use IDR for non-cpu bound sources' paths.")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-1-f88c4a3ecfe9@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-sysfs.c b/drivers/hwtracing/coresight/coresight-sysfs.c
index b6a870399e8341..da6f22b512c92a 100644
--- a/drivers/hwtracing/coresight/coresight-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-sysfs.c
@@ -244,8 +244,10 @@ int coresight_enable_sysfs(struct coresight_device *csdev)
 		 */
 		hash = hashlen_hash(hashlen_string(NULL, dev_name(&csdev->dev)));
 		ret = idr_alloc_u32(&path_idr, path, &hash, hash, GFP_KERNEL);
-		if (ret)
+		if (ret) {
+			coresight_disable_source_sysfs(csdev, NULL);
 			goto err_source;
+		}
 		break;
 	default:
 		/* We can't be here */
-- 
2.53.0



