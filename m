Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEFE246327;
	Tue, 20 May 2025 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749522; cv=none; b=C3uCnbsa9a7jL+I0vHcD+ln5nQrIk6f/U+/dbKsi0CnE17K6iLu5s+E8lFN6ykqwX6mTIp/TJVEjPTVBsIN7rt+E/JitxCwt3/9rFx3PUgft264SyEVyEosryI1P26ZAUNDbYjbsIyW9d6b0kPwkSmTMauTO8Xqdey08eXMYS1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749522; c=relaxed/simple;
	bh=YXwr4lT2Z8Fcr/BKzEYEBH9Y+w5Ily5hLRZrWV5dOls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rICj1kTge4JD/GmjhZvf8uSLEGu+IAJ55Hxs314kEoFZzmRve0VLAH2oBVBiZheHKfhibKSl2ftAEdGI64CxL2V8gAoi1akLpmdwZyop/qUk+4+lXJSOyg+s7uw6MNgxjg/uzdj8jNISPTbeBxa4DWh02PLMI8egGN6ucMantKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIwNWOs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIwNWOs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4730CC4CEEA;
	Tue, 20 May 2025 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749521;
	bh=YXwr4lT2Z8Fcr/BKzEYEBH9Y+w5Ily5hLRZrWV5dOls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIwNWOs/tDkj7Azx24FdqQjMFhPZTpJxhnqhRl/lnroY4M6KltLd6NmnKicvJf2Q8
	 1JjQYmDazrvrgyfsYA4yPym4ax08258qiLrxkUkQp7vipwmzaXMap6MnRKqObnqg7V
	 iJ6nwv1ohtVwkNDgH423UwkpnACrKKmZwKNlPptQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 72/97] dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call
Date: Tue, 20 May 2025 15:50:37 +0200
Message-ID: <20250520125803.472579627@linuxfoundation.org>
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

commit d5449ff1b04dfe9ed8e455769aa01e4c2ccf6805 upstream.

The remove call stack is missing idxd cleanup to free bitmap, ida and
the idxd_device. Call idxd_free() helper routines to make sure we exit
gracefully.

Fixes: bfe1d56091c1 ("dmaengine: idxd: Init and probe for Intel data accelerators")
Cc: stable@vger.kernel.org
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250404120217.48772-9-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -796,6 +796,7 @@ static void idxd_remove(struct pci_dev *
 	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
+	idxd_free(idxd);
 }
 
 static struct pci_driver idxd_pci_driver = {


