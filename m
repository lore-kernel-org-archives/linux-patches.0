Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0F35BDA5;
	Wed,  3 Dec 2025 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778937; cv=none; b=hA9Dr8e13QEBu9X7DSYNTuW6qolFW0twUx8HVE04PqnfBIzK5/LSTetFkU8ZgHe6litbczwSYtfl1FOQ2K3t2djID07yL4QufUpvv8vAGFNz5xkmrUxw77WIXPM/ih0uofc1NKlUaA2PKeDPyWxIz7p/vKiJJG+kzZ1wje7Pqbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778937; c=relaxed/simple;
	bh=jJW2Yk7nhIQp+KQ0oeoeHadXEhYnQejtPdiKY08SWek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaEYmkpOjF4n3k6iYc7nvMTxutMlbW0ZMK+CFEu6gXnuKgGVjLq7HZ7umuU81PcTxE2jDPkpziC58s0+ZoIIUWqJvHxbdPmGql7cbjHy7xsWi8BguOz6f+9EI2FOHM4vXbPDjE7fwDvJSe8px2DUbdcjnHoTe90WuEgZL2ffzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUjxKK25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUjxKK25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA26C4CEF5;
	Wed,  3 Dec 2025 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778937;
	bh=jJW2Yk7nhIQp+KQ0oeoeHadXEhYnQejtPdiKY08SWek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUjxKK25CFaYtk/1E1X3XNrjw2bmK1eagx39/pEXtu60tpjQVxnCllNTWyp3SkerN
	 27qKNiVeGcyYT8yDP5NtVHbhBRUKMNmtYCy7ab2KvTI3R+dwiJuiOj6DrygfurGJkO
	 Zy+g1vnyB5ONPffughY0qzorllBLjZmiQwdIuGQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 073/568] drivers: base: cacheinfo: Update cpu_map_populated during CPU Hotplug
Date: Wed,  3 Dec 2025 16:21:15 +0100
Message-ID: <20251203152443.390105345@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

[ Upstream commit c26fabe73330d983c7ce822c6b6ec0879b4da61f ]

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
Signed-off-by: Wen Yang <wen.yang@linux.dev>
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


