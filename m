Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1985E4B1471;
	Mon, 31 Aug 2026 13:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184243; cv=none; b=sucssZRVzr6DtNn/2MJK9AEIYgvwG292NIMMn+GBBt9lS53YJ9sBOlWNpd1LXqqZTKS4dyF5qxvqLsBHVxId07gxfkmdPmjE+vSIg3bq3ulB+Kj3vkJsUZlSUiF320wfqBE98ZygdYL8yNDfApmESfk+nUQGeMbeeg622AnSAaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184243; c=relaxed/simple;
	bh=yhDZTZs6kbz7jxMfNWQxUiE3bQ96nNITl4fqSy+djR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldoYjju9wVV+4Q1TXyYzJILQxFVCNzymfi+QwnH6AU7GgZmC5RxpJP/OTSFWXV9hI6ZXl0/spugPowXEPoz6RKyOJuOCw0TeqYJiHc7BU+d6lmnOL4/ZlKZ6ppL18FKKRxaGJB8pApnw0hr3Fqm1HbDM8XbPuannabLyfgqxpCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocVSU9Yp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocVSU9Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FF51F00ACA;
	Mon, 31 Aug 2026 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184241;
	bh=DXaqTwS7TvSwxy7Ao48hKDv4hz7RLY7ay1IMUUkiKz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ocVSU9YpbfDGTd5f7cZEcbA4DOuws+YObJSTwHPkSb0wxF+oCXMztzFEQEflCeT4W
	 EY2uS8SbaRL+uXasg5MKCxNVXIy77rBUodQhGQVzdAiov8+/I7imuEMIEjDHLg1pR8
	 RVJ7Z3cPnHNewS0xpwd+KPWYGvCp3zmq6dvhByK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 39/99] powerpc/hv-gpci: fix preempt count leak in sysfs show paths
Date: Mon, 31 Aug 2026 15:34:08 +0200
Message-ID: <20260831133401.953921562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

[ Upstream commit dbc30a57bd8e026995e9fa8e8c31cffd18542c01 ]

Four sysfs show() callbacks in hv-gpci take get_cpu_var(hv_gpci_reqb)
(which calls preempt_disable()) but only call the matching put_cpu_var()
on the error path under the 'out:' label. Every successful read leaks
one preempt_disable():

  processor_bus_topology_show()
  processor_config_show()
  affinity_domain_via_virtual_processor_show()
  affinity_domain_via_domain_show()

(affinity_domain_via_partition_show() was already correct.)

On a CONFIG_PREEMPT=y kernel, repeated reads raise preempt_count and
eventually return to userspace with preemption still disabled. The
next user-mode page fault then hits faulthandler_disabled() == 1,
gets forced to SIGSEGV, and the resulting coredump trips
'BUG: scheduling while atomic' in call_usermodehelper_exec ->
wait_for_completion_state -> schedule:

  BUG: scheduling while atomic: <task>/<pid>/0x00000004
  ...
  __schedule_bug+0x6c/0x90
  __schedule+0x58c/0x13a0
  schedule+0x48/0x1a0
  schedule_timeout+0x104/0x170
  wait_for_completion_state+0x16c/0x330
  call_usermodehelper_exec+0x254/0x2d0
  vfs_coredump+0x1050/0x2590
  get_signal+0xb9c/0xc80
  do_notify_resume+0xf8/0x470

Add an out_success label that calls put_cpu_var() before returning
the byte count, mirroring affinity_domain_via_partition_show().

Fixes: 71f1c39647d8 ("powerpc/hv_gpci: Add sysfs file inside hv_gpci device to show processor bus topology information")
Fixes: 1a160c2a13c6 ("powerpc/hv_gpci: Add sysfs file inside hv_gpci device to show processor config information")
Fixes: 71a7ccb478fc ("powerpc/hv_gpci: Add sysfs file inside hv_gpci device to show affinity domain via virtual processor information")
Fixes: a69a57cac1ec ("powerpc/hv_gpci: Add sysfs file inside hv_gpci device to show affinity domain via domain information")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260508041256.3447113-1-aboorvad@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-gpci.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 241551d1282f8..0ec0bd3110652 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -210,7 +210,7 @@ static ssize_t processor_bus_topology_show(struct device *dev, struct device_att
 			0, 0, buf, &n, arg);
 
 	if (!ret)
-		return n;
+		goto out_success;
 
 	if (ret != H_PARAMETER)
 		goto out;
@@ -244,12 +244,14 @@ static ssize_t processor_bus_topology_show(struct device *dev, struct device_att
 				starting_index, 0, buf, &n, arg);
 
 		if (!ret)
-			return n;
+			goto out_success;
 
 		if (ret != H_PARAMETER)
 			goto out;
 	}
 
+out_success:
+	put_cpu_var(hv_gpci_reqb);
 	return n;
 
 out:
@@ -278,7 +280,7 @@ static ssize_t processor_config_show(struct device *dev, struct device_attribute
 			0, 0, buf, &n, arg);
 
 	if (!ret)
-		return n;
+		goto out_success;
 
 	if (ret != H_PARAMETER)
 		goto out;
@@ -312,12 +314,14 @@ static ssize_t processor_config_show(struct device *dev, struct device_attribute
 				starting_index, 0, buf, &n, arg);
 
 		if (!ret)
-			return n;
+			goto out_success;
 
 		if (ret != H_PARAMETER)
 			goto out;
 	}
 
+out_success:
+	put_cpu_var(hv_gpci_reqb);
 	return n;
 
 out:
@@ -346,7 +350,7 @@ static ssize_t affinity_domain_via_virtual_processor_show(struct device *dev,
 			0, 0, buf, &n, arg);
 
 	if (!ret)
-		return n;
+		goto out_success;
 
 	if (ret != H_PARAMETER)
 		goto out;
@@ -382,12 +386,14 @@ static ssize_t affinity_domain_via_virtual_processor_show(struct device *dev,
 				starting_index, secondary_index, buf, &n, arg);
 
 		if (!ret)
-			return n;
+			goto out_success;
 
 		if (ret != H_PARAMETER)
 			goto out;
 	}
 
+out_success:
+	put_cpu_var(hv_gpci_reqb);
 	return n;
 
 out:
@@ -416,7 +422,7 @@ static ssize_t affinity_domain_via_domain_show(struct device *dev, struct device
 			0, 0, buf, &n, arg);
 
 	if (!ret)
-		return n;
+		goto out_success;
 
 	if (ret != H_PARAMETER)
 		goto out;
@@ -448,12 +454,14 @@ static ssize_t affinity_domain_via_domain_show(struct device *dev, struct device
 					starting_index, 0, buf, &n, arg);
 
 		if (!ret)
-			return n;
+			goto out_success;
 
 		if (ret != H_PARAMETER)
 			goto out;
 	}
 
+out_success:
+	put_cpu_var(hv_gpci_reqb);
 	return n;
 
 out:
-- 
2.53.0



