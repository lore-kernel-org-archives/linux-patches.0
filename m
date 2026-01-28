Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC449301465;
	Wed, 28 Jan 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615180; cv=none; b=hvwscbPGXdklVSsNmfrm/Vs3EoFVg6DDClRW6iX3rGPuQUjqzoJav7QDjenQWz/kx/ezhhtJS7RbPXb0mj02Qzq1S5svR5wCjx97OyDqS3+omLRa7NPaJLGgPKR/vxRDxEbw+W/0AND9MmixnFOQhgrLbeFoFQwwK3GWZrpZ588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615180; c=relaxed/simple;
	bh=xerMyxEx3Qzge01mSxFhsdQpDjh66uTpQ93x2898dCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtWGI4sUQ+yCXEix8YCX8wJsEBCa2QXy0GgsaHOyakap0kTKM88NA70d6B+h7OGYQZ7/jolJIh35PqS59BZ1JMjT0medlweKi+s/sG8HAFisUocILdu4am1HlfVBbX6rqvg3YHTjML6qKGp2QOd4HT0VvyGTkq2Kfh07QSDeux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16ULM+Ol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16ULM+Ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB17C4CEF1;
	Wed, 28 Jan 2026 15:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615180;
	bh=xerMyxEx3Qzge01mSxFhsdQpDjh66uTpQ93x2898dCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16ULM+OlDQjPhQx/weE/JANgheYUOypQ6wN1kqWyjYHia9E3Esim3YUUQa3UIXxFZ
	 uIDkqo4emlQmvGv5VCSR0JV7EiKyWn7Q3UcMVEtKQOLpBfgnHx6eBLUewHoD3rgOKa
	 9fi11/SXEpCeGk7kN36lQ8hxb7BtP8WvA676oiWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 102/169] of: fix reference count leak in of_alias_scan()
Date: Wed, 28 Jan 2026 16:23:05 +0100
Message-ID: <20260128145337.679876007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Weigang He <geoffreyhe2@gmail.com>

commit 81122fba08fa3ccafab6ed272a5c6f2203923a7e upstream.

of_find_node_by_path() returns a device_node with its refcount
incremented. When kstrtoint() fails or dt_alloc() fails, the function
continues to the next iteration without calling of_node_put(), causing
a reference count leak.

Add of_node_put(np) before continue on both error paths to properly
release the device_node reference.

Fixes: 611cad720148 ("dt: add of_alias_scan and of_alias_get_id")
Cc: stable@vger.kernel.org
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Link: https://patch.msgid.link/20260117091238.481243-1-geoffreyhe2@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1822,13 +1822,17 @@ void of_alias_scan(void * (*dt_alloc)(u6
 			end--;
 		len = end - start;
 
-		if (kstrtoint(end, 10, &id) < 0)
+		if (kstrtoint(end, 10, &id) < 0) {
+			of_node_put(np);
 			continue;
+		}
 
 		/* Allocate an alias_prop with enough space for the stem */
 		ap = dt_alloc(sizeof(*ap) + len + 1, __alignof__(*ap));
-		if (!ap)
+		if (!ap) {
+			of_node_put(np);
 			continue;
+		}
 		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);


