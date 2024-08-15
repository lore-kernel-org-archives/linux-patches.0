Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577F01714A8;
	Thu, 15 Aug 2024 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729377; cv=none; b=AgJ8mwyQ0WvS1q0G3VTfJFk3eGmmdPjLE0woTvwJ7VK2cVIWsA38oEaufG4/vVLiQBtSAXVz/2zzU4aScnmOtihCfiqZWjbKJ7yVCvw2YE6eBjVgcMaT2hYY4ySC+a1Y/D/1nnXjEzUPcntNZ6CiQp2E+4hFV+CqsMWr/3FC8uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729377; c=relaxed/simple;
	bh=gWjVIuMRBLDed0YsS5lOWJANS7mFHN9z5z16ZjpV4/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksz32vN62aBh/XF0vvJMfKlCLKWNXBIgiXwReQ6tf1Q1xEzJEulJcphc1+3bM/LtU6EbykgDsWxp4g+TRomckqRkNrmDkforrvfK1+sKUpOksPssRexUI4Gy7LDzlmwV1b6H6kLol1n/qcnp7pjiCTfO++0E4UQn7gNzvtRAy8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgaJeJ4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgaJeJ4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E6EC32786;
	Thu, 15 Aug 2024 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729377;
	bh=gWjVIuMRBLDed0YsS5lOWJANS7mFHN9z5z16ZjpV4/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgaJeJ4++6+V6bQ+zE+v++Cr1D6Do0bVLLl4qVn3GEsCXWwg1ndW39SouGQ4Bv36r
	 2uN4kjc4n5K6c2rO30Jjve6wqNMJ3nGXIDPlF6kJaXQGNBhFEySu/8AlOMxeQAKa6C
	 OBfVC/YRREu8xSelrzO8flLi5GX7ETjmVWNZrmrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/484] selftests: forwarding: devlink_lib: Wait for udev events after reloading
Date: Thu, 15 Aug 2024 15:18:57 +0200
Message-ID: <20240815131944.335796146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit f67a90a0c8f5b3d0acc18f10650d90fec44775f9 ]

Lately, an additional locking was added by commit c0a40097f0bc
("drivers: core: synchronize really_probe() and dev_uevent()"). The
locking protects dev_uevent() calling. This function is used to send
messages from the kernel to user space. Uevent messages notify user space
about changes in device states, such as when a device is added, removed,
or changed. These messages are used by udev (or other similar user-space
tools) to apply device-specific rules.

After reloading devlink instance, udev events should be processed. This
locking causes a short delay of udev events handling.

One example for useful udev rule is renaming ports. 'forwading.config'
can be configured to use names after udev rules are applied. Some tests run
devlink_reload() and immediately use the updated names. This worked before
the above mentioned commit was pushed, but now the delay of uevent messages
causes that devlink_reload() returns before udev events are handled and
tests fail.

Adjust devlink_reload() to not assume that udev events are already
processed when devlink reload is done, instead, wait for udev events to
ensure they are processed before returning from the function.

Without this patch:
TESTS='rif_mac_profile' ./resource_scale.sh
TEST: 'rif_mac_profile' 4                                           [ OK ]
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp1/disable_ipv6: No such file or directory
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp1/disable_ipv6: No such file or directory
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp2/disable_ipv6: No such file or directory
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp2/disable_ipv6: No such file or directory
Cannot find device "swp1"
Cannot find device "swp2"
TEST: setup_wait_dev (: Interface swp1 does not come up.) [FAIL]

With this patch:
$ TESTS='rif_mac_profile' ./resource_scale.sh
TEST: 'rif_mac_profile' 4                                           [ OK ]
TEST: 'rif_mac_profile' overflow 5                                  [ OK ]

This is relevant not only for this test.

Fixes: bc7cbb1e9f4c ("selftests: forwarding: Add devlink_lib.sh")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/89367666e04b38a8993027f1526801ca327ab96a.1720709333.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 2c14a86adaaae..6bb0f929dad78 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -122,6 +122,8 @@ devlink_reload()
 	still_pending=$(devlink resource show "$DEVLINK_DEV" | \
 			grep -c "size_new")
 	check_err $still_pending "Failed reload - There are still unset sizes"
+
+	udevadm settle
 }
 
 declare -A DEVLINK_ORIG
-- 
2.43.0



