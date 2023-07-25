Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BF81ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6BFC433CA;
	Tue, 25 Jul 2023 11:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283469;
	bh=WFh5B1GLpMXvek8MLQow5XE6m+VK4+Y6j0kcvOs6bSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDWIdqf/SXBGuvTyir3HtF2ljEo4XVmAjk3+ZwkDNq3ujYq0J8u1CniGOFM/R//NG
	 OjrnwUf3aQIRF+vnDhHu+znyFGqFRIKCXctnOtIxfKEyfLabraTWFGLsR0kGjLeLba
	 OYn5Frlc1UEIMdBbvlXSC5vKAm3rKtKQVG2ufJw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Tsuchiya Yuto <kitakar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Anastasia Belova <abelova@astralinux.ru>
Subject: [PATCH 5.10 001/509] media: atomisp: fix "variable dereferenced before check asd"
Date: Tue, 25 Jul 2023 12:39:00 +0200
Message-ID: <20230725104553.672575710@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tsuchiya Yuto <kitakar@gmail.com>

commit ac56760a8bbb4e654b2fd54e5de79dd5d72f937d upstream.

There are two occurrences where the variable 'asd' is dereferenced
before check. Fix this issue by using the variable after the check.

Link: https://lore.kernel.org/linux-media/20211122074122.GA6581@kili/

Link: https://lore.kernel.org/linux-media/20211201141904.47231-1-kitakar@gmail.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Igned-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_cmd.c   |    3 ++-
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -5243,7 +5243,7 @@ static int atomisp_set_fmt_to_isp(struct
 	int (*configure_pp_input)(struct atomisp_sub_device *asd,
 				  unsigned int width, unsigned int height) =
 				      configure_pp_input_nop;
-	u16 stream_index = atomisp_source_pad_to_stream_id(asd, source_pad);
+	u16 stream_index;
 	const struct atomisp_in_fmt_conv *fc;
 	int ret, i;
 
@@ -5252,6 +5252,7 @@ static int atomisp_set_fmt_to_isp(struct
 			__func__, vdev->name);
 		return -EINVAL;
 	}
+	stream_index = atomisp_source_pad_to_stream_id(asd, source_pad);
 
 	v4l2_fh_init(&fh.vfh, vdev);
 
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1123,7 +1123,7 @@ int __atomisp_reqbufs(struct file *file,
 	struct ia_css_frame *frame;
 	struct videobuf_vmalloc_memory *vm_mem;
 	u16 source_pad = atomisp_subdev_source_pad(vdev);
-	u16 stream_id = atomisp_source_pad_to_stream_id(asd, source_pad);
+	u16 stream_id;
 	int ret = 0, i = 0;
 
 	if (!asd) {
@@ -1131,6 +1131,7 @@ int __atomisp_reqbufs(struct file *file,
 			__func__, vdev->name);
 		return -EINVAL;
 	}
+	stream_id = atomisp_source_pad_to_stream_id(asd, source_pad);
 
 	if (req->count == 0) {
 		mutex_lock(&pipe->capq.vb_lock);


