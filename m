Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656DF1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE76C433C7;
	Fri, 21 Jul 2023 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955889;
	bh=HKBEmBd27pcF6D8aceliQSWbvgzbOnfwvtRzJVyaHd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwsP6k92KDzudaEHhEVRATtqByG6/RcgD5hkTz/TnkcmUTCtDo05FglmXT7b4ddDv
	 pQRMnSLDhMvfZZByXzDJjNrLppC1qfHctHstZB2EvNq+0NutISGq00HuWkEHuU336O
	 sBMr57/0ztCbs4v2h6dFUvj3HkDnXRVylqXz9XCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Michael Kelley <mikelley@microsoft.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 065/292] HID: hyperv: avoid struct memcpy overrun warning
Date: Fri, 21 Jul 2023 18:02:54 +0200
Message-ID: <20230721160531.583982861@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5f151364b1da6bd217632fd4ee8cc24eaf66a497 ]

A previous patch addressed the fortified memcpy warning for most
builds, but I still see this one with gcc-9:

In file included from include/linux/string.h:254,
                 from drivers/hid/hid-hyperv.c:8:
In function 'fortify_memcpy_chk',
    inlined from 'mousevsc_on_receive' at drivers/hid/hid-hyperv.c:272:3:
include/linux/fortify-string.h:583:4: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  583 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

My guess is that the WARN_ON() itself is what confuses gcc, so it no
longer sees that there is a correct range check. Rework the code in a
way that helps readability and avoids the warning.

Fixes: 542f25a94471 ("HID: hyperv: Replace one-element array with flexible-array member")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20230705140242.844167-1-arnd@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-hyperv.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
index 49d4a26895e76..f33485d83d24f 100644
--- a/drivers/hid/hid-hyperv.c
+++ b/drivers/hid/hid-hyperv.c
@@ -258,19 +258,17 @@ static void mousevsc_on_receive(struct hv_device *device,
 
 	switch (hid_msg_hdr->type) {
 	case SYNTH_HID_PROTOCOL_RESPONSE:
+		len = struct_size(pipe_msg, data, pipe_msg->size);
+
 		/*
 		 * While it will be impossible for us to protect against
 		 * malicious/buggy hypervisor/host, add a check here to
 		 * ensure we don't corrupt memory.
 		 */
-		if (struct_size(pipe_msg, data, pipe_msg->size)
-			> sizeof(struct mousevsc_prt_msg)) {
-			WARN_ON(1);
+		if (WARN_ON(len > sizeof(struct mousevsc_prt_msg)))
 			break;
-		}
 
-		memcpy(&input_dev->protocol_resp, pipe_msg,
-				struct_size(pipe_msg, data, pipe_msg->size));
+		memcpy(&input_dev->protocol_resp, pipe_msg, len);
 		complete(&input_dev->wait_event);
 		break;
 
-- 
2.39.2



