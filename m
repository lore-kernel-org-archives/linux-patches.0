Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C108A3955CA;
	Tue, 12 May 2026 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608626; cv=none; b=Tug37ktX9KYL6eEcQWgxlaowM6o/5PbM1f2Q6vaVS2Acr9KnWCJga03aA4+4j5XOqqkQcK+wrYU8ej03nZFtITj8zIaDK362biYAM4/FhYihm08hJLH9HCIeYgrsgGDKFpuIAHfWCbjHMU6X2slwE1UGty4xgl4jqLPGSayrmUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608626; c=relaxed/simple;
	bh=H6iiCWoxJiLUD67b8yA5p4zD+ISTNT81Xk74gie6UWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK2ZD70xboc1NfSKXTijkNVH5Der7Tg6UN1nptTuqjVoix+2FfEhycCBQ0AXz0iOrrXCSteP8rTfEJ9SIwOEhFxlPWdMfIiR7O0vnbK45z0XSJIHASVs86wgK0kgBKtidrFfMQLwJIrCKNvZGPSRK54+zI4wBPePETRaxU0bscI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oclOqCHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oclOqCHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D0CC2BCB0;
	Tue, 12 May 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608626;
	bh=H6iiCWoxJiLUD67b8yA5p4zD+ISTNT81Xk74gie6UWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oclOqCHAOMTsVBYv/mk92KweEVGLFHWLVf4n1K+RhH53pvkruajBnq9NTf1Y8plBG
	 n1BQwArA8hfhkMEQ/OOgF3TbUv+gY/ZvTkVhd0JiK8+LgjgaKNk2uotKLkLwkSTCfX
	 uUsvTfX+wAwODkgoiociK7hEemd3dqWq1R9Hl8p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 6.18 151/270] dm: dont report warning when doing deferred remove
Date: Tue, 12 May 2026 19:39:12 +0200
Message-ID: <20260512173941.629639653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit b7cce3e2cca9cd78418f3c3784474b778e7996fe upstream.

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -384,7 +384,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


