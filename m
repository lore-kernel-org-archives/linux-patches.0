Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3418216A3D;
	Thu,  7 Nov 2024 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730999274; cv=none; b=VG9dketRt3+usxnootqLB7usK3w/9Md9j+EKn3oGK9omc4j1sqx6UfX4hT+4EcXk1QHGWKpSvhX0I1YDIwwFcge1V5uzLn1cAClqtmppV2FuzW7BePLyj4ldUmjCP1ZMwXdlwCsrFBsl9FPjgWMoLrVz764OJIZLZUTOjY4hutA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730999274; c=relaxed/simple;
	bh=kvUT+khP930NGF0HmUa/dWU+0BG6GwU79nU9P//qm68=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=W3TvREMINVT5P6VWB6U2xjf3TbLVjEAYhS4CocnfruGK4hCHqrP8dCPVjZgnMNuf0KeAX3fRrCrFy8TsaT1O1g6OoAn7QHnUBVZFnn/Is74QBpgbSfhfj+/lGdA464G+6xYs9ApkfSM7zwE1L/xjQyOQNoR2Rq6/5u4Z+NAUyE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEC8sJRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEC8sJRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C31BC4CECC;
	Thu,  7 Nov 2024 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730999273;
	bh=kvUT+khP930NGF0HmUa/dWU+0BG6GwU79nU9P//qm68=;
	h=From:Date:Subject:To:Cc:From;
	b=gEC8sJRZ8gMxxEpZb1iwmYzNjYetnK6M+drcGZpGFeVeh5L9CMSoCrkQvVMCQ+Iq5
	 7tvoRAoQqL2q+R7EyqKW7V+YonMtKmvIzZTTGzcgoNFUdGgpOiPRQ2sXGrSxB1cgJ7
	 kIx57KbTe+PrSbKrLwE/FoMwa23k/ixWZDsYbqgPuhA+p2DVk6FHmfkPSQsxcjYhgn
	 L9o8JSeGszuc4mJGUXnZYXHYTJnucF6mFHo426bN6DDI0AWgI2bJtQjDY/z1wdYttL
	 gGmkLd1hi4ipD5obrsUIdOMYPcaskR0J42BDCWuNHONQbrEiz4UVjE8gkE8n2iVTRT
	 0sNyK6XcQHPBg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 07 Nov 2024 10:07:43 -0700
Subject: [PATCH] cdx: Fix cdx_mmap_resource() after constifying attr in
 ->mmap()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAN7zLGcC/x2MQQqAMAzAviI9W7AyFf2KeBhbpz04ZRVRxL87P
 IaQPKCchBWG4oHEp6hsMQOVBbjFxplRfGaoq9oQVR3qrUHRbVEPXFe7Y5ALnb+QTNP1ZAJT6yH
 ne+Ks/vU4ve8HRfu1p2oAAAA=
X-Change-ID: 20241107-sysfs-const-mmap-fix-cdx-1457914fe16d
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Nipun Gupta <nipun.gupta@amd.com>, Nikhil Agarwal <nikhil.agarwal@amd.com>, 
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1716; i=nathan@kernel.org;
 h=from:subject:message-id; bh=kvUT+khP930NGF0HmUa/dWU+0BG6GwU79nU9P//qm68=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOk6n18YffyTlf/OXKFYPGf3udOzX81Kqkh6fMO15F/O/
 juGPZt+dpSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJ1Lgw/FO5cY879aZyrjv/
 hpk3+jrFn/27+9a+ZOnEyjPft54xm1bI8L/gVnUE05bmFPZ9lyZ+j/h0679m8/51wiFrPt1zuT9
 fxpwZAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 94a20fb9af16 ("sysfs: treewide: constify attribute callback of
bin_attribute::mmap()") missed updating the attr parameter of
cdx_mmap_resource(), resulting in a build failure.

  drivers/cdx/cdx.c: In function 'cdx_create_res_attr':
  drivers/cdx/cdx.c:773:24: error: assignment to 'int (*)(struct file *, struct kobject *, const struct bin_attribute *, struct vm_area_struct *)' from incompatible pointer type 'int (*)(struct file *, struct kobject *, struct bin_attribute *, struct vm_area_struct *)' [-Wincompatible-pointer-types]
    773 |         res_attr->mmap = cdx_mmap_resource;
        |                        ^

Update cdx_mmap_resource() to match, resolving the build failure.

Fixes: 94a20fb9af16 ("sysfs: treewide: constify attribute callback of bin_attribute::mmap()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/cdx/cdx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdx/cdx.c b/drivers/cdx/cdx.c
index 07371cb653d356977cbd3dd99a1b848146d5a993..316bd89a95caf97163a126478985c52b1b596bb4 100644
--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -707,7 +707,7 @@ static const struct vm_operations_struct cdx_phys_vm_ops = {
  * Return: true on success, false otherwise.
  */
 static int cdx_mmap_resource(struct file *fp, struct kobject *kobj,
-			     struct bin_attribute *attr,
+			     const struct bin_attribute *attr,
 			     struct vm_area_struct *vma)
 {
 	struct cdx_device *cdx_dev = to_cdx_device(kobj_to_dev(kobj));

---
base-commit: 298c2af4788ed027a42c2bab0f210219825fb5fd
change-id: 20241107-sysfs-const-mmap-fix-cdx-1457914fe16d

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

