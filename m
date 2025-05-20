Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5462459FE;
	Tue, 20 May 2025 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749607; cv=none; b=BhVIlZtydXZ59c+fjjBSVjKWxKfjVXRr6/aAfc+I9z+6vD6FVCM0oSy+fhtsBfF5iOFe1IIiLol57SIHvMsCy/JCYM3b+KZnLc3ujHksihH4mHDXZ1Ph49Y2kcj4wqajkSyaOkvMGUaLqxBJFpcEGRzWlO5C6ccajG1l/VtbkG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749607; c=relaxed/simple;
	bh=L/1jm9B6Cr1N6T31S0vJ+673MMWLwR4AEgCTDGJGUrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz3O7O/hwn1Awp2YMxYMLTUHz7900SS1s2gGXSHcwYMkodmfRFhswte0LjYBCHlsMJdFTFSSsWXDzfEVv6KkW83bgwDHTDnrIvIZospr9FWVTgJZXELzDAxqhkXS+chn2q/k0Zf1mQYHBC23KJIGHNJJS/wdwx72NJ1b+w1+6rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pO6Q+cRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO6Q+cRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71929C4CEE9;
	Tue, 20 May 2025 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749606;
	bh=L/1jm9B6Cr1N6T31S0vJ+673MMWLwR4AEgCTDGJGUrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO6Q+cRrUacaNiUuZFNsW2jWk2T+ehbFifMR5OvS+CtKdp5JoWDhyXtyCIdqw+l3R
	 LyLhDDcpZmToFQjCk1AFjOy+FWYuNy4MSmkhyfS75huto8EPqOy7x/F+0bp+TnIAdo
	 GuvPnHrp3T8qG7IJ+UnhpMou+y3U3qXwdAaeSWEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 68/97] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
Date: Tue, 20 May 2025 15:50:33 +0200
Message-ID: <20250520125803.317801598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 817bced19d1dbdd0b473580d026dc0983e30e17b upstream.

Memory allocated for engines is not freed if an error occurs during
idxd_setup_engines(). To fix it, free the allocated memory in the
reverse order of allocation before exiting the function in case of an
error.

Fixes: 75b911309060 ("dmaengine: idxd: fix engine conf_dev lifetime")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-3-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -259,6 +259,7 @@ static int idxd_setup_engines(struct idx
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(engine);
 			goto err;
 		}
 
@@ -272,7 +273,10 @@ static int idxd_setup_engines(struct idx
 		engine = idxd->engines[i];
 		conf_dev = engine_confdev(engine);
 		put_device(conf_dev);
+		kfree(engine);
 	}
+	kfree(idxd->engines);
+
 	return rc;
 }
 


