Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76263E0091;
	Fri, 15 May 2026 16:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862098; cv=none; b=A4FFNMDOU4AHb0r8XBv6T4tQnhXACjBc6m7tvuhzKi8SdPf0hUglw0OF7iZKgthS/FZIg5gx4OdyIVgTmc01sw80HjB7yoFq8GXfk3Zd1oWKci9nMmBjyzYbKzyic2tXcMhme0B1jAaI9TkRaou6NsYTwipJSkreXs+JocXlT2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862098; c=relaxed/simple;
	bh=e6juknc3XaYzuGZfz6NU4xlhMcyHgKGZTtHSP57AseQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPaZYx7yrob1FfhZL9I+L58vFG/AcRBHBmNy8tB2BWmkCSqbkSY2ns7z27Xsd0naswxzKtKJH+Bwfkx5Z9lSc4cB7LXtNacU57Uan/2nwLdIRuFqsIUdhBBR7DtYMtOrh6Zew/DP4oHs0lFy57FcUzCExWO5t+fgVoRqTvM070o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ97dYlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ97dYlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6C6C2BCB3;
	Fri, 15 May 2026 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862097;
	bh=e6juknc3XaYzuGZfz6NU4xlhMcyHgKGZTtHSP57AseQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ97dYlm8E1QaUflh96yKX3JAxL2shir76ySJ16um/NKxgTEQwkKamFxZu4E3Yu9A
	 WmQK8cm8uq8U29TN21fNsRktxE+NJLBHi1CyhbED6cD9dMJOGYNkfDzWyr0II5EDQP
	 RquoupICbX8ZP9pLWw8/MoWZe5lNIStqzu26Mbew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 105/188] drm/amdkfd: Add upper bound check for num_of_nodes
Date: Fri, 15 May 2026 17:48:42 +0200
Message-ID: <20260515154659.608163620@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Alysa Liu <Alysa.Liu@amd.com>

commit 74b73fa56a395d46745e4f245225963e9f8be7f1 upstream.

drm/amdkfd: Add upper bound check for num_of_nodes
in kfd_ioctl_get_process_apertures_new.

Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 98ff46a5ea090c14d2cdb4f5b993b05d74f3949f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c  |    3 +++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h     |    1 +
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c |   11 +++++++++++
 3 files changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -763,6 +763,9 @@ static int kfd_ioctl_get_process_apertur
 		goto out_unlock;
 	}
 
+	if (args->num_of_nodes > kfd_topology_get_num_devices())
+		return -EINVAL;
+
 	/* Fill in process-aperture information for all available
 	 * nodes, but not more than args->num_of_nodes as that is
 	 * the amount of memory allocated by user
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1175,6 +1175,7 @@ static inline struct kfd_node *kfd_node_
 	return NULL;
 }
 int kfd_topology_enum_kfd_devices(uint8_t idx, struct kfd_node **kdev);
+uint32_t kfd_topology_get_num_devices(void);
 int kfd_numa_node_to_apic_id(int numa_node_id);
 
 /* Interrupts */
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -2295,6 +2295,17 @@ int kfd_topology_remove_device(struct kf
 	return res;
 }
 
+uint32_t kfd_topology_get_num_devices(void)
+{
+	uint32_t num_devices;
+
+	down_read(&topology_lock);
+	num_devices = sys_props.num_devices;
+	up_read(&topology_lock);
+
+	return num_devices;
+}
+
 /* kfd_topology_enum_kfd_devices - Enumerate through all devices in KFD
  *	topology. If GPU device is found @idx, then valid kfd_dev pointer is
  *	returned through @kdev


