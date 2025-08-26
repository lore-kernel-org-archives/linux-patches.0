Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F63342CAE;
	Tue, 26 Aug 2025 11:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207841; cv=none; b=WD0f4tuhDC7kf9VHvi/qcPWD+6sctTNhAFSsZzC+VEJzRj4RFu993qrJco9fZLlYtUSXHlDjPgyONi1a1pXqF5V8D6JqCONABNPKkQFTwlNj/8S0hA3BtVIxSRcrEcFu5p0q5o31KF8G+molnR4+YxpFpvBNG2EDJUT+QTQRDiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207841; c=relaxed/simple;
	bh=LFwBq6n9TSrYg+HuBWiHqPT3iSIlPuV5Jrkce57zpe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRk3MJrQQuw5zc2d0LQyDgAkBBb4Nusj/GDikdaYNzQ+XYIl2RKx+eU8vRU77MmYBeaNFDopc5ZTxgIRGVFVdObOiNx06sTFSxD5sy2gLoDIaXAHfS6WfFh9lOXtL7JFbb1uLflBu9mH+g6Cumtbr9h+/H1QWA1ZwJWOMn75mpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14vh/2mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14vh/2mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA531C4CEF1;
	Tue, 26 Aug 2025 11:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207841;
	bh=LFwBq6n9TSrYg+HuBWiHqPT3iSIlPuV5Jrkce57zpe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14vh/2mYjIdEYnshvQWAZdeSi04MDrFKcbbsQa9F8QqTgR30GHyGEmx4XQR17+jt5
	 TGWkdvjYtHm49CSM82O7et9xb/YXMOsl3ObeDrfZ/189elFhh9r2Kv6b7poGDiCwIJ
	 IlxztWp17xVBj+wQFkkTSt9iK4Fw94UVWjcoyQ6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@resnulli.us>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Calvin Owens <calvin@wbinvd.org>
Subject: [PATCH 6.16 337/457] devlink: let driver opt out of automatic phys_port_name generation
Date: Tue, 26 Aug 2025 13:10:21 +0200
Message-ID: <20250826110945.660753446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit c5ec7f49b480db0dfc83f395755b1c2a7c979920 ]

Currently when adding devlink port, phys_port_name is automatically
generated within devlink port initialization flow. As a result adding
devlink port support to driver may result in forced changes of interface
names, which breaks already existing network configs.

This is an expected behavior but in some scenarios it would not be
preferable to provide such limitation for legacy driver not being able to
keep 'pre-devlink' interface name.

Add flag no_phys_port_name to devlink_port_attrs struct which indicates
if devlink should not alter name of interface.

Suggested-by: Jiri Pirko <jiri@resnulli.us>
Link: https://lore.kernel.org/all/nbwrfnjhvrcduqzjl4a2jafnvvud6qsbxlvxaxilnryglf4j7r@btuqrimnfuly/
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: stable@vger.kernel.org # 6.16
Tested-By: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/devlink.h |    6 +++++-
 net/devlink/port.c    |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -78,6 +78,9 @@ struct devlink_port_pci_sf_attrs {
  * @flavour: flavour of the port
  * @split: indicates if this is split port
  * @splittable: indicates if the port can be split.
+ * @no_phys_port_name: skip automatic phys_port_name generation; for
+ *		       compatibility only, newly added driver/port instance
+ *		       should never set this.
  * @lanes: maximum number of lanes the port supports. 0 value is not passed to netlink.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
  * @phys: physical port attributes
@@ -87,7 +90,8 @@ struct devlink_port_pci_sf_attrs {
  */
 struct devlink_port_attrs {
 	u8 split:1,
-	   splittable:1;
+	   splittable:1,
+	   no_phys_port_name:1;
 	u32 lanes;
 	enum devlink_port_flavour flavour;
 	struct netdev_phys_item_id switch_id;
--- a/net/devlink/port.c
+++ b/net/devlink/port.c
@@ -1519,7 +1519,7 @@ static int __devlink_port_phys_port_name
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int n = 0;
 
-	if (!devlink_port->attrs_set)
+	if (!devlink_port->attrs_set || devlink_port->attrs.no_phys_port_name)
 		return -EOPNOTSUPP;
 
 	switch (attrs->flavour) {


