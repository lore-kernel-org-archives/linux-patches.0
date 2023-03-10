Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75B7882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E952C433D2;
	Fri, 10 Mar 2023 15:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461215;
	bh=fI7CotlMsLlDkTVS+E+4UC6pqgSvzurq+2ExBeIu+LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynUO1mEUhuFxodJvjfs2FNAGmrromhO7ID6hbb8hL7TGEcoi1KX0bbZiHwjtJBj1J
	 i5BEE3xvqvVLwf7YAH3bG01zFm95SVDQMWIV6MM4vpH3f0PE1/F+h0IcYlWw9TiYzM
	 OseeyoUHCskLQr3jRQV+KU9Wq/uQ7YtV8qmYPNyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/136] um: virtio_uml: free command if adding to virtqueue failed
Date: Fri, 10 Mar 2023 14:42:35 +0100
Message-Id: <20230310133708.035407740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 8a6ca543646f2940832665dbf4e04105262505e2 ]

If adding the command fails (i.e. the virtqueue is broken) then free it
again if the function allocated a new buffer for it.

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 0ab58016db22f..2829347d1e906 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -131,8 +131,11 @@ static int um_pci_send_cmd(struct um_pci_device *dev,
 				out ? 1 : 0,
 				posted ? cmd : HANDLE_NO_FREE(cmd),
 				GFP_ATOMIC);
-	if (ret)
+	if (ret) {
+		if (posted)
+			kfree(cmd);
 		goto out;
+	}
 
 	if (posted) {
 		virtqueue_kick(dev->cmd_vq);
-- 
2.39.2



