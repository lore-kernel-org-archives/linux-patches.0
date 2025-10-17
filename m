Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC8D335074;
	Fri, 17 Oct 2025 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715355; cv=none; b=nEvNIuRvKq9k0vDBXwAjQdr16KAk6xnzYsfFFtGDNGZLqmqQRZbrF6b/fiT3Ek1b1LMlT+lmCTkdH4ESJc8uv23zaMlsckhwJobIHKVnaKpiYzY1PmkPGODOxTolhZk9hkmPghFIO4a/WDtKPqzOsq650qEjRJ3+9eltTNmnObk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715355; c=relaxed/simple;
	bh=qAanRGAIgSo+uxHkcMSrj1zormgUSuFm3WcGMHkh4G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxeKcK/77tD+1e+hKBFWhODcBSSXEL/HtluuaJL98929zQ4g+PcarQRY830Ehd5EKYTPhC2agV8ll2jcfncnI3QLcQINxCCSlzNOAYASMgTqXi3zbzKPd9rUd6hofIBSAGJtVSEt7Zc5pZcQ1cL9WC/qiwymWb5f38Kd2cIqy+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEsMnBjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEsMnBjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F32C4CEE7;
	Fri, 17 Oct 2025 15:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715355;
	bh=qAanRGAIgSo+uxHkcMSrj1zormgUSuFm3WcGMHkh4G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEsMnBjKPOWs1hogfrTWA9WQkz1eyCFM8RcO6/7Zv54epBGcGJa5OTB8g2wwdgE/w
	 wOKaar9foKeslkwkqBKMbHnKeyx5TSSph5kPeGn9jnaqcA13nvRESMw1r1P2BnOZIl
	 33LU1TUevKK6oYX0XBALX7KgeT+LqZvFVB0g/Nx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.17 187/371] drm/panthor: Fix memory leak in panthor_ioctl_group_create()
Date: Fri, 17 Oct 2025 16:52:42 +0200
Message-ID: <20251017145208.689038652@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit ca2a6abdaee43808034cdb218428d2ed85fd3db8 upstream.

When bailing out due to group_priority_permit() failure, the queue_args
need to be freed. Fix it by rearranging the function to use the
goto-on-error pattern, such that the success case flows straight without
indentation while error cases jump forward to cleanup.

Cc: stable@vger.kernel.org
Fixes: 5f7762042f8a ("drm/panthor: Restrict high priorities on group_create")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20241113-panthor-fix-gcq-bailout-v1-1-654307254d68@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_drv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1103,14 +1103,15 @@ static int panthor_ioctl_group_create(st
 
 	ret = group_priority_permit(file, args->priority);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = panthor_group_create(pfile, args, queue_args);
-	if (ret >= 0) {
-		args->group_handle = ret;
-		ret = 0;
-	}
+	if (ret < 0)
+		goto out;
+	args->group_handle = ret;
+	ret = 0;
 
+out:
 	kvfree(queue_args);
 	return ret;
 }


