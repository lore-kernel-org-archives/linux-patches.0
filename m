Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68C0145B22;
	Fri,  6 Dec 2024 14:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496329; cv=none; b=mh+umWs595RI8IhMWNvVd9N7/LuH2lE1HUzCw85yRNWDjlnDAC+WP835rdc1Gwi6Oh9o+T/b5gVSHhHymPKFnfKmTUMnyKU8L8F63Pbqoy5w00UGNj1ysPoyPt+4mOP8CrrixYVRQuOtaWFyhmc0HTmE2it/YLG0AGCQkuIit/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496329; c=relaxed/simple;
	bh=ID/GAFYRDObEhSbFqlzfF1weHbTWmA7SHhtWW8W0JXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFZi8Q5Dnl766EIUDX564v4bdjDi6B8gN5TwoKqJWIWgJm51TFUvBLhFGw92GxQobJJoUBaEK9TG+s7+PCAaevlQXryV3fvg0PZOpmwHsQy0oGFgEszuyMbhnM9cjs/3lMTAo4gk7rjdjHLaEp3oeSf802BdC8NDnp3TAs7ofcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP6okNgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP6okNgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D5C4CED1;
	Fri,  6 Dec 2024 14:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496329;
	bh=ID/GAFYRDObEhSbFqlzfF1weHbTWmA7SHhtWW8W0JXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zP6okNgQ4dz7oCwCzA5Kl+DWqXYYdIttwJxa8/M8hqxHQCSLebFI8vgFJAq3fapKm
	 KlB1b6fNjL++cLNV0RQ66qQJmwNOuqhydIPJ1Q/t1Vioh0y4G0i3lEnVrMcky5MoL3
	 ZR+s/AXRSpHct/BNlq2ccPPSbg13Ge0aDemwVkdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 089/146] fs/proc/kcore.c: Clear ret value in read_kcore_iter after successful iov_iter_zero
Date: Fri,  6 Dec 2024 15:37:00 +0100
Message-ID: <20241206143531.082666571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 088f294609d8f8816dc316681aef2eb61982e0da upstream.

If iov_iter_zero succeeds after failed copy_from_kernel_nofault,
we need to reset the ret value to zero otherwise it will be returned
as final return value of read_kcore_iter.

This fixes objdump -d dump over /proc/kcore for me.

Cc: stable@vger.kernel.org
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Fixes: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20241121231118.3212000-1-jolsa@kernel.org
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/kcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -600,6 +600,7 @@ static ssize_t read_kcore_iter(struct ki
 					ret = -EFAULT;
 					goto out;
 				}
+				ret = 0;
 			/*
 			 * We know the bounce buffer is safe to copy from, so
 			 * use _copy_to_iter() directly.


