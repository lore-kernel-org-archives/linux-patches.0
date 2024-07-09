Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F027713;
	Tue,  9 Jul 2024 11:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524439; cv=none; b=Lt/SwXQRsYbCU9yT7xSyyyqk0TJB9a1uMbRj/ry6cUSKbC4OpHqYI9gpdzeYLrgC7B5bMb9m6MVRaCSQO9vJf7mxzg37FnenVmbAOcPSyqE6cckoJYGwCrPSsvLw152tm8vJ0xqzTa7sRBo1PTL/z7e2znLUvPb5wj8IgrICqaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524439; c=relaxed/simple;
	bh=ia5D9z3P8eXsJCj5ENngACOuMTukVLxISSi1IyWF+TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Won8QPgQ+KvR52iwtETzFyo+20kdXFfzd92JxHXXwDZjPpZRuUC2AyrgAGCysEzI6pqwXochewo5sHJJoe2UkfGZDoJFUg6aIVUBh5/Zn3btbxZeJqpjddjj5IQSVuEvR1+itvlurSAkjlnMLQPQF9ahHBB5gOotb4ioxcj7J/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+6pjWd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+6pjWd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC560C3277B;
	Tue,  9 Jul 2024 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524439;
	bh=ia5D9z3P8eXsJCj5ENngACOuMTukVLxISSi1IyWF+TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+6pjWd8seAseMeQ4qf8CFdisSAX1ylMbP0JA0ETDgiPeDJrXyuwWMrpgRjwtINjP
	 PYg0YZTF02/zmuRGS8EjJMzPv3N6zv48myxvWVyKQQShUuaYftzjLqFgQAO24Ffxtp
	 IFQnzfgUZxZoYyZZtUnMZNnYczCn4D5UMeKjYnTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petri Kaukasoina <petri.kaukasoina@tuni.fi>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 182/197] swap: yield device immediately
Date: Tue,  9 Jul 2024 13:10:36 +0200
Message-ID: <20240709110715.986769067@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 712182b67e831912f90259102ae334089e7bccd1 ]

Otherwise we can cause spurious EBUSY issues when trying to mount the
rootfs later on.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218845
Reported-by: Petri Kaukasoina <petri.kaukasoina@tuni.fi>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/swap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 5bc04bfe2db1d..c6f24d17866d8 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1600,7 +1600,7 @@ int swsusp_check(bool exclusive)
 
 put:
 		if (error)
-			fput(hib_resume_bdev_file);
+			bdev_fput(hib_resume_bdev_file);
 		else
 			pr_debug("Image signature found, resuming\n");
 	} else {
-- 
2.43.0



