Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E02B1DB92A;
	Tue, 12 Aug 2025 18:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023700; cv=none; b=tEBTMdqY1ecZwcmNwpbq6fI32LQ9913W07U7n58HyDsE9krhIPTZMoqEyYm2mBJ1OyJ5GOsvYT4AGiQ3pL0dA21dhgIkOR7vCEp2+QLX16ivCgvbZGGhlk8GhGB5IYve176h5XlX/isc2K04dAnmYYQutJQqoSc8h0LwH3mU5PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023700; c=relaxed/simple;
	bh=Q67NjmQUs3mRaA2qSsHEC7O7S+Rvf4fmuQEEYo+jBL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hF3oltL9N+ouDJdYhM/9KrhOyFy3BIkWwuVXoZp5mhPBtZKq/uoShzusb7dKBEWdMnlx/OvxUoy3LVVs1i+yymICSneqzZuoqawBrgaTvA/UHkBGxkiSB7gaNXSlAL+11L6gHbf/2gJK/3g2CdBZkIm9n1rCDpQ11+9TBOIiV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBEi9zU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBEi9zU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B604DC4CEF0;
	Tue, 12 Aug 2025 18:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023700;
	bh=Q67NjmQUs3mRaA2qSsHEC7O7S+Rvf4fmuQEEYo+jBL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBEi9zU6ymV5zgMUXyIjp5kaGN2qi9g02tqiCrVTkZOdz033tvRAl6spbR+DtcGsE
	 LJ5k9Vsoh3+i8sTKfIaIAb7ZK23siJ6I24TTeRWzX33e6kgk8L9J4m+s9O5yeUGgDZ
	 TgYof30amAPkaWZzwXXRuRvX6nK4Jj34jVqC69mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kowshik Jois <kowsjois@linux.ibm.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 156/627] powerpc/pseries/dlpar: Search DRC index from ibm,drc-indexes for IO add
Date: Tue, 12 Aug 2025 19:27:31 +0200
Message-ID: <20250812173425.220370471@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit 41a1452759a8b1121df9cf7310acf31d766ba70b ]

IO hotplug add event is handled in the user space with drmgr tool.
After the device is enabled, the user space uses /sys/kernel/dlpar
interface with “dt add index <drc_index>” to update the device tree.
The kernel interface (dlpar_hp_dt_add()) finds the parent node for
the specified ‘drc_index’ from ibm,drc-info property. The recent FW
provides this property from 2017 onwards. But KVM guest code in
some releases is still using the older SLOF firmware which has
ibm,drc-indexes property instead of ibm,drc-info.

If the ibm,drc-info is not available, this patch adds changes to
search ‘drc_index’ from the indexes array in ibm,drc-indexes
property to support old FW.

Fixes: 02b98ff44a57 ("powerpc/pseries/dlpar: Add device tree nodes for DLPAR IO add")
Reported-by: Kowshik Jois <kowsjois@linux.ibm.com>
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Tested-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250531235002.239213-1-haren@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/dlpar.c | 52 +++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 213aa26dc8b3..979487da6522 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -404,6 +404,45 @@ get_device_node_with_drc_info(u32 index)
 	return NULL;
 }
 
+static struct device_node *
+get_device_node_with_drc_indexes(u32 drc_index)
+{
+	struct device_node *np = NULL;
+	u32 nr_indexes, index;
+	int i, rc;
+
+	for_each_node_with_property(np, "ibm,drc-indexes") {
+		/*
+		 * First element in the array is the total number of
+		 * DRC indexes returned.
+		 */
+		rc = of_property_read_u32_index(np, "ibm,drc-indexes",
+				0, &nr_indexes);
+		if (rc)
+			goto out_put_np;
+
+		/*
+		 * Retrieve DRC index from the list and return the
+		 * device node if matched with the specified index.
+		 */
+		for (i = 0; i < nr_indexes; i++) {
+			rc = of_property_read_u32_index(np, "ibm,drc-indexes",
+							i+1, &index);
+			if (rc)
+				goto out_put_np;
+
+			if (drc_index == index)
+				return np;
+		}
+	}
+
+	return NULL;
+
+out_put_np:
+	of_node_put(np);
+	return NULL;
+}
+
 static int dlpar_hp_dt_add(u32 index)
 {
 	struct device_node *np, *nodes;
@@ -423,10 +462,19 @@ static int dlpar_hp_dt_add(u32 index)
 		goto out;
 	}
 
+	/*
+	 * Recent FW provides ibm,drc-info property. So search
+	 * for the user specified DRC index from ibm,drc-info
+	 * property. If this property is not available, search
+	 * in the indexes array from ibm,drc-indexes property.
+	 */
 	np = get_device_node_with_drc_info(index);
 
-	if (!np)
-		return -EIO;
+	if (!np) {
+		np = get_device_node_with_drc_indexes(index);
+		if (!np)
+			return -EIO;
+	}
 
 	/* Next, configure the connector. */
 	nodes = dlpar_configure_connector(cpu_to_be32(index), np);
-- 
2.39.5



