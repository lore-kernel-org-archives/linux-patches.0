Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8158259CBD;
	Tue, 17 Feb 2026 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361155; cv=none; b=KQiJW4kh4QbnpUqO4okDObK+v8lGRXpC+mNnj4xIS+an9HRlQhSGimUe4GzcSmNRriqolpSau1sRCANwI7XGHR9DJsmLhe6wU1/tnYlAY15AHbtrm3x0Wa6vNjWK9SH5FkVXfRMgzDSAUebhtjiSPlDszrTnEYX20LKYOiMEUhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361155; c=relaxed/simple;
	bh=Cf0CvEbOZGWbSp61z+3aEAsJ+itmH45+AHfXORft10A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2ocO2vtIKYJaHwH6nBaO8edu0Gi4xvbxTugRZSc3SbcxXnN3ZuoxsWiNixtfLgxlJOXRYftnyk/Hmqql/FYUpSgyXhuLPatx5GHlymuDet31fQWnvJXwBGQ8P3fHK06MHypFFp5Ra0MNm4507ozDcRECTirgaWxKC8pX2ylhMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1nUEIan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1nUEIan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1589BC4CEF7;
	Tue, 17 Feb 2026 20:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361155;
	bh=Cf0CvEbOZGWbSp61z+3aEAsJ+itmH45+AHfXORft10A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1nUEIanMzbkJL0C5frf9pYoTvifyIdpXw0XQf5c3r9ZbpV4HifRLC64fhI4Ulufq
	 b7ThZNDu0X699Em8Sjx31vKhoMGLvlrq8QaQup5kCGf/gPbZnhgqQxwT5gmvCgR8YH
	 WdUcNeg01Zr8NHq3uAjkXTTyLl4JoXmeus9eBn5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/64] PCI: endpoint: Automatically create a function specific attributes group
Date: Tue, 17 Feb 2026 21:31:14 +0100
Message-ID: <20260217200008.198444159@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 70b3740f2c1941e2006d61539131b70d20cba9a6 ]

A PCI endpoint function driver can define function specific attributes
under its function configfs directory using the add_cfs() endpoint driver
operation. This is done by tying up the mkdir operation for the function
configfs directory to a call to the add_cfs() operation.  However, there
are no checks preventing the user from repeatedly creating function
specific attribute directories with different names, resulting in the same
endpoint specific attributes group being added multiple times, which also
result in an invalid reference counting for the attribute groups. E.g.,
using the pci-epf-ntb function driver as an example, the user creates the
function as follows:

  $ modprobe pci-epf-ntb
  $ cd /sys/kernel/config/pci_ep/functions/pci_epf_ntb
  $ mkdir func0
  $ tree func0
  func0/
  |-- baseclass_code
  |-- cache_line_size
  |-- ...
  `-- vendorid

  $ mkdir func0/attrs
  $ tree func0
  func0/
  |-- attrs
  |   |-- db_count
  |   |-- mw1
  |   |-- mw2
  |   |-- mw3
  |   |-- mw4
  |   |-- num_mws
  |   `-- spad_count
  |-- baseclass_code
  |-- cache_line_size
  |-- ...
  `-- vendorid

At this point, the function can be started by linking the EP controller.
However, if the user mistakenly creates again a directory:

  $ mkdir func0/attrs2
  $ tree func0
  func0/
  |-- attrs
  |   |-- db_count
  |   |-- mw1
  |   |-- mw2
  |   |-- mw3
  |   |-- mw4
  |   |-- num_mws
  |   `-- spad_count
  |-- attrs2
  |   |-- db_count
  |   |-- mw1
  |   |-- mw2
  |   |-- mw3
  |   |-- mw4
  |   |-- num_mws
  |   `-- spad_count
  |-- baseclass_code
  |-- cache_line_size
  |-- ...
  `-- vendorid

The endpoint function specific attributes are duplicated and cause a crash
when the endpoint function device is torn down:

  refcount_t: addition on 0; use-after-free.
  WARNING: CPU: 2 PID: 834 at lib/refcount.c:25 refcount_warn_saturate+0xc8/0x144
  CPU: 2 PID: 834 Comm: rmdir Not tainted 6.3.0-rc1 #1
  Hardware name: Pine64 RockPro64 v2.1 (DT)
  pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  ...
  Call trace:
  refcount_warn_saturate+0xc8/0x144
  config_item_get+0x7c/0x80
  configfs_rmdir+0x17c/0x30c
  vfs_rmdir+0x8c/0x204
  do_rmdir+0x158/0x184
  __arm64_sys_unlinkat+0x64/0x80
  invoke_syscall+0x48/0x114
  ...

Fix this by modifying pci_epf_cfs_work() to execute the new function
pci_ep_cfs_add_type_group() which itself calls pci_epf_type_add_cfs() to
obtain the function specific attribute group and the group name (directory
name) from the endpoint function driver. If the function driver defines an
attribute group, pci_ep_cfs_add_type_group() then proceeds to register this
group using configfs_register_group(), thus automatically exposing the
function type specific configfs attributes to the user. E.g.:

  $ modprobe pci-epf-ntb
  $ cd /sys/kernel/config/pci_ep/functions/pci_epf_ntb
  $ mkdir func0
  $ tree func0
  func0/
  |-- baseclass_code
  |-- cache_line_size
  |-- ...
  |-- pci_epf_ntb.0
  |   |-- db_count
  |   |-- mw1
  |   |-- mw2
  |   |-- mw3
  |   |-- mw4
  |   |-- num_mws
  |   `-- spad_count
  |-- primary
  |-- ...
  `-- vendorid

With this change, there is no need for the user to create or delete
directories in the endpoint function attributes directory. The
pci_epf_type_group_ops group operations are thus removed.

Also update the documentation for the pci-epf-ntb and pci-epf-vntb function
drivers to reflect this change, removing the explanations showing the need
to manually create the sub-directory for the function specific attributes.

Link: https://lore.kernel.org/r/20230415023542.77601-2-dlemoal@kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Stable-dep-of: 7c5c7d06bd1f ("PCI: endpoint: Avoid creating sub-groups asynchronously")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/PCI/endpoint/pci-ntb-howto.rst  |   11 ++----
 Documentation/PCI/endpoint/pci-vntb-howto.rst |   13 +++-----
 drivers/pci/endpoint/pci-ep-cfs.c             |   42 ++++++++++++--------------
 3 files changed, 29 insertions(+), 37 deletions(-)

--- a/Documentation/PCI/endpoint/pci-ntb-howto.rst
+++ b/Documentation/PCI/endpoint/pci-ntb-howto.rst
@@ -88,13 +88,10 @@ commands can be used::
 	# echo 0x104c > functions/pci_epf_ntb/func1/vendorid
 	# echo 0xb00d > functions/pci_epf_ntb/func1/deviceid
 
-In order to configure NTB specific attributes, a new sub-directory to func1
-should be created::
-
-	# mkdir functions/pci_epf_ntb/func1/pci_epf_ntb.0/
-
-The NTB function driver will populate this directory with various attributes
-that can be configured by the user::
+The PCI endpoint framework also automatically creates a sub-directory in the
+function attribute directory. This sub-directory has the same name as the name
+of the function device and is populated with the following NTB specific
+attributes that can be configured by the user::
 
 	# ls functions/pci_epf_ntb/func1/pci_epf_ntb.0/
 	db_count    mw1         mw2         mw3         mw4         num_mws
--- a/Documentation/PCI/endpoint/pci-vntb-howto.rst
+++ b/Documentation/PCI/endpoint/pci-vntb-howto.rst
@@ -84,13 +84,10 @@ commands can be used::
 	# echo 0x1957 > functions/pci_epf_vntb/func1/vendorid
 	# echo 0x0809 > functions/pci_epf_vntb/func1/deviceid
 
-In order to configure NTB specific attributes, a new sub-directory to func1
-should be created::
-
-	# mkdir functions/pci_epf_vntb/func1/pci_epf_vntb.0/
-
-The NTB function driver will populate this directory with various attributes
-that can be configured by the user::
+The PCI endpoint framework also automatically creates a sub-directory in the
+function attribute directory. This sub-directory has the same name as the name
+of the function device and is populated with the following NTB specific
+attributes that can be configured by the user::
 
 	# ls functions/pci_epf_vntb/func1/pci_epf_vntb.0/
 	db_count    mw1         mw2         mw3         mw4         num_mws
@@ -103,7 +100,7 @@ A sample configuration for NTB function
 	# echo 1 > functions/pci_epf_vntb/func1/pci_epf_vntb.0/num_mws
 	# echo 0x100000 > functions/pci_epf_vntb/func1/pci_epf_vntb.0/mw1
 
-A sample configuration for virtual NTB driver for virutal PCI bus::
+A sample configuration for virtual NTB driver for virtual PCI bus::
 
 	# echo 0x1957 > functions/pci_epf_vntb/func1/pci_epf_vntb.0/vntb_vid
 	# echo 0x080A > functions/pci_epf_vntb/func1/pci_epf_vntb.0/vntb_pid
--- a/drivers/pci/endpoint/pci-ep-cfs.c
+++ b/drivers/pci/endpoint/pci-ep-cfs.c
@@ -23,6 +23,7 @@ struct pci_epf_group {
 	struct config_group group;
 	struct config_group primary_epc_group;
 	struct config_group secondary_epc_group;
+	struct config_group *type_group;
 	struct delayed_work cfs_work;
 	struct pci_epf *epf;
 	int index;
@@ -502,34 +503,29 @@ static struct configfs_item_operations p
 	.release		= pci_epf_release,
 };
 
-static struct config_group *pci_epf_type_make(struct config_group *group,
-					      const char *name)
-{
-	struct pci_epf_group *epf_group = to_pci_epf_group(&group->cg_item);
-	struct config_group *epf_type_group;
-
-	epf_type_group = pci_epf_type_add_cfs(epf_group->epf, group);
-	return epf_type_group;
-}
-
-static void pci_epf_type_drop(struct config_group *group,
-			      struct config_item *item)
-{
-	config_item_put(item);
-}
-
-static struct configfs_group_operations pci_epf_type_group_ops = {
-	.make_group     = &pci_epf_type_make,
-	.drop_item      = &pci_epf_type_drop,
-};
-
 static const struct config_item_type pci_epf_type = {
-	.ct_group_ops	= &pci_epf_type_group_ops,
 	.ct_item_ops	= &pci_epf_ops,
 	.ct_attrs	= pci_epf_attrs,
 	.ct_owner	= THIS_MODULE,
 };
 
+static void pci_ep_cfs_add_type_group(struct pci_epf_group *epf_group)
+{
+	struct config_group *group;
+
+	group = pci_epf_type_add_cfs(epf_group->epf, &epf_group->group);
+	if (!group)
+		return;
+
+	if (IS_ERR(group)) {
+		dev_err(&epf_group->epf->dev,
+			"failed to create epf type specific attributes\n");
+		return;
+	}
+
+	configfs_register_group(&epf_group->group, group);
+}
+
 static void pci_epf_cfs_work(struct work_struct *work)
 {
 	struct pci_epf_group *epf_group;
@@ -547,6 +543,8 @@ static void pci_epf_cfs_work(struct work
 		pr_err("failed to create 'secondary' EPC interface\n");
 		return;
 	}
+
+	pci_ep_cfs_add_type_group(epf_group);
 }
 
 static struct config_group *pci_epf_make(struct config_group *group,


