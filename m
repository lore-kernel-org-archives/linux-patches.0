Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25D30E0C2;
	Mon, 13 Oct 2025 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367423; cv=none; b=KH12S+gRl1zhBMqMFv6VU16gs//NDo1DtExoeTuZyalr3RzjWMmTIquoR+M7ss5pIHxpUPpaowgktJjdmzWxfWMnIZL1PFtkafKxe4MSLUxLUVGTUp6Jg6CRftPyNzemwRITERIJ5WjD15cQnod3c9Zw9xNhqgkStcLlviOi4OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367423; c=relaxed/simple;
	bh=WsncMvwM61F8z+h+RP2U9gO9Q76IhEwlBLqvsBYGFpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRoCW7I+f3xoxupocAKjteZVDsHplBndkL2Gf7T2Vfpdrv3wh/OzZSvvbNQhNPM/WlEX6wkt0dnFe+v/a1bpc8lS3GybFuEvVH8jbC+yTlRW2dCULA0+WprSBLskHdy8iLftX5os4Da1nE7DMfXdNv9t2ihUu3krPUMvrmuLWtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znNiN5Lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znNiN5Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A8AC4CEE7;
	Mon, 13 Oct 2025 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367422;
	bh=WsncMvwM61F8z+h+RP2U9gO9Q76IhEwlBLqvsBYGFpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znNiN5LwmFwQQdfckN3jYexcFn+98SU855rwThj3z1ba4eIwcFA3t5T4XfezbMcZS
	 K+solpY+OpzM6mUFJC0IAOSlyeq2XxbzXTv2flPoTCnb1oeC4thpUTlEjBBFY7afqT
	 Ws4ER3U0IJsuaJ/Jv3zUyZUOyGtxL6+DTgKeOVXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 196/196] drivers: base: cacheinfo: Update cpu_map_populated during CPU Hotplug
Date: Mon, 13 Oct 2025 16:46:09 +0200
Message-ID: <20251013144321.780632270@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

commit c26fabe73330d983c7ce822c6b6ec0879b4da61f upstream.

Until commit 5c2712387d48 ("cacheinfo: Fix LLC is not exported through
sysfs"), cacheinfo called populate_cache_leaves() for CPU coming online
which let the arch specific functions handle (at least on x86)
populating the shared_cpu_map. However, with the changes in the
aforementioned commit, populate_cache_leaves() is not called when a CPU
comes online as a result of hotplug since last_level_cache_is_valid()
returns true as the cacheinfo data is not discarded. The CPU coming
online is not present in shared_cpu_map, however, it will not be added
since the cpu_cacheinfo->cpu_map_populated flag is set (it is set in
populate_cache_leaves() when cacheinfo is first populated for x86)

This can lead to inconsistencies in the shared_cpu_map when an offlined
CPU comes online again. Example below depicts the inconsistency in the
shared_cpu_list in cacheinfo when CPU8 is offlined and onlined again on
a 3rd Generation EPYC processor:

  # for i in /sys/devices/system/cpu/cpu8/cache/index*/shared_cpu_list; do echo -n "$i: "; cat $i; done
    /sys/devices/system/cpu/cpu8/cache/index0/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index1/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index2/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index3/shared_cpu_list: 8-15,136-143

  # echo 0 > /sys/devices/system/cpu/cpu8/online
  # echo 1 > /sys/devices/system/cpu/cpu8/online

  # for i in /sys/devices/system/cpu/cpu8/cache/index*/shared_cpu_list; do echo -n "$i: "; cat $i; done
    /sys/devices/system/cpu/cpu8/cache/index0/shared_cpu_list: 8
    /sys/devices/system/cpu/cpu8/cache/index1/shared_cpu_list: 8
    /sys/devices/system/cpu/cpu8/cache/index2/shared_cpu_list: 8
    /sys/devices/system/cpu/cpu8/cache/index3/shared_cpu_list: 8

  # cat /sys/devices/system/cpu/cpu136/cache/index0/shared_cpu_list
    136

  # cat /sys/devices/system/cpu/cpu136/cache/index3/shared_cpu_list
    9-15,136-143

Clear the flag when the CPU is removed from shared_cpu_map when
cache_shared_cpu_map_remove() is called during CPU hotplug. This will
allow cache_shared_cpu_map_setup() to add the CPU coming back online in
the shared_cpu_map. Set the flag again when the shared_cpu_map is setup.
Following are results of performing the same test as described above with
the changes:

  # for i in /sys/devices/system/cpu/cpu8/cache/index*/shared_cpu_list; do echo -n "$i: "; cat $i; done
    /sys/devices/system/cpu/cpu8/cache/index0/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index1/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index2/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index3/shared_cpu_list: 8-15,136-143

  # echo 0 > /sys/devices/system/cpu/cpu8/online
  # echo 1 > /sys/devices/system/cpu/cpu8/online

  # for i in /sys/devices/system/cpu/cpu8/cache/index*/shared_cpu_list; do echo -n "$i: "; cat $i; done
    /sys/devices/system/cpu/cpu8/cache/index0/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index1/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index2/shared_cpu_list: 8,136
    /sys/devices/system/cpu/cpu8/cache/index3/shared_cpu_list: 8-15,136-143

  # cat /sys/devices/system/cpu/cpu136/cache/index0/shared_cpu_list
    8,136

  # cat /sys/devices/system/cpu/cpu136/cache/index3/shared_cpu_list
    8-15,136-143

Fixes: 5c2712387d48 ("cacheinfo: Fix LLC is not exported through sysfs")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20230508084115.1157-3-kprateek.nayak@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -365,11 +365,14 @@ static int cache_shared_cpu_map_setup(un
 			coherency_max_size = this_leaf->coherency_line_size;
 	}
 
+	/* shared_cpu_map is now populated for the cpu */
+	this_cpu_ci->cpu_map_populated = true;
 	return 0;
 }
 
 static void cache_shared_cpu_map_remove(unsigned int cpu)
 {
+	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *this_leaf, *sib_leaf;
 	unsigned int sibling, index, sib_index;
 
@@ -404,6 +407,9 @@ static void cache_shared_cpu_map_remove(
 		if (of_have_populated_dt())
 			of_node_put(this_leaf->fw_token);
 	}
+
+	/* cpu is no longer populated in the shared map */
+	this_cpu_ci->cpu_map_populated = false;
 }
 
 static void free_cache_attributes(unsigned int cpu)


