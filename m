Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C438433AD;
	Mon, 15 Apr 2024 14:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192050; cv=none; b=Kz2Njb8GQh1TouojTeCzFIj4EXcslzchT079b2jjrK79B21J/8cYYgCx4gDPGe63fZBaKz9ZgA9TeAE5ELQRXfKCmg9qMvMHFLbzNo+ha6ijfiA062EUxmHDxM1R/2GHA5bOIDBP1F4JKEdfszZbMTqTi7Gi23lvDPF09uAPGKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192050; c=relaxed/simple;
	bh=DepV+6yKwbHsbkXjq6ofk98Hh345GGt3b+nZFsAqh6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcjLzbSF+OTxNirb6s0ex3MN5+cBoAHrOeehpuVzvgr3nwznPh4svkAk0FSkoOit5tkTP2YVK4N5gKAaZWhpdrdok9mQ43O/+QryfdgAYZP53By02E9bXasov6QYKAGH6mf7qFDZVZPLCQf9/WJymV6DSiPxvOuYHSgnDzEmhjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdMDjirK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdMDjirK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76E5C113CC;
	Mon, 15 Apr 2024 14:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192050;
	bh=DepV+6yKwbHsbkXjq6ofk98Hh345GGt3b+nZFsAqh6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdMDjirKsR0I1rFIJ74nOCJVpoC2uW2+TLnqhsORvdd3Qw7kbUiVwJR0mMi8TVCHN
	 r9CLlmv7nQk0KWm2zsU6SFIDbfD6zjzybxGZ4h5K4iX8QAWSQT0pC5pyiGUYs8lLgS
	 G+FQrMftv2nFRP9t4Y66veJkyWwNSeLnycOb8T9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>
Subject: [PATCH 6.1 47/69] drm/amdkfd: Reset GPU on queue preemption failure
Date: Mon, 15 Apr 2024 16:21:18 +0200
Message-ID: <20240415141947.584891194@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit 8bdfb4ea95ca738d33ef71376c21eba20130f2eb upstream.

Currently, with F32 HWS GPU reset is only when unmap queue fails.

However, if compute queue doesn't repond to preemption request in time
unmap will return without any error. In this case, only preemption error
is logged and Reset is not triggered. Call GPU reset in this case also.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1805,6 +1805,7 @@ static int unmap_queues_cpsch(struct dev
 		pr_err("HIQ MQD's queue_doorbell_id0 is not 0, Queue preemption time out\n");
 		while (halt_if_hws_hang)
 			schedule();
+		kfd_hws_hang(dqm);
 		return -ETIME;
 	}
 


