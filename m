Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415082C76;
	Thu, 13 Jun 2024 12:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280145; cv=none; b=ZSZ3+AdR7JT89q0e/DlWRodbXekFVYO/PIvwk3h+jmH1yrk5xNObodAWk3In0spfogfuHKRvGIXNzb1W2qoolqnv8HV8kNetlDFBo+NGXwr79FhOMVR9737h01AF5485GOQdCeFrBU5IxMIc8Sjw+08WghbnNr/qy4Wnj8TPEI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280145; c=relaxed/simple;
	bh=wn0xuqeZgI7k7WLooMNNa+d/dUmuVjvucbDhtsgsoiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4d+QlWWlP0kvSPVnsjp2vZ6bvtwrMk5hJ3vHFgpGrzuJwpopZq5J6xJLu1a4nf7jUJeIVhpW97UTQPuwAqPEdq+/go2pvb8zYbKOhqlfAt1RGs1q0XsDhcOm3VkVDvxKKY8wtEhNoLbV2ZDhfmwL90MM+N+k2utSxQ/782Myr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1Um5hGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1Um5hGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C04C4AF1A;
	Thu, 13 Jun 2024 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280144;
	bh=wn0xuqeZgI7k7WLooMNNa+d/dUmuVjvucbDhtsgsoiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1Um5hGxYGyHXNnTOlMQoPVYN+lur1gOTjsZeq6oqFht93LQATlcPrCftwTDZN2QQ
	 2WwE7tdfTvjiTn4AAbOIICjA8PE80qgoBS6v6vy4Q+Z4NVoB7SfjKn39aym1QHoOVC
	 DR3ttajqbpa0A9JGzACnZ4bg50TYxuokwMxJdk2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Johannes Berg <johannes@sipsolutions.net>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/202] um: Fix return value in ubd_init()
Date: Thu, 13 Jun 2024 13:33:45 +0200
Message-ID: <20240613113232.664188601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 31a5990ed253a66712d7ddc29c92d297a991fdf2 ]

When kmalloc_array() fails to allocate memory, the ubd_init()
should return -ENOMEM instead of -1. So, fix it.

Fixes: f88f0bdfc32f ("um: UBD Improvements")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 4e59ab817d3e7..a4e531f0e3b96 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1157,7 +1157,7 @@ static int __init ubd_init(void)
 
 	if (irq_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	io_req_buffer = kmalloc_array(UBD_REQ_BUFFER_SIZE,
 				      sizeof(struct io_thread_req *),
@@ -1168,7 +1168,7 @@ static int __init ubd_init(void)
 
 	if (io_req_buffer == NULL) {
 		printk(KERN_ERR "Failed to initialize ubd buffering\n");
-		return -1;
+		return -ENOMEM;
 	}
 	platform_driver_register(&ubd_driver);
 	mutex_lock(&ubd_lock);
-- 
2.43.0



