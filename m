Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E92108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F69C433EF;
	Mon, 24 Apr 2023 13:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343164;
	bh=LT55Mn/UfNnoYqllf3TgRjC4VCY9DWM25uqgDMO6Oh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQeUy83gX1VGugNsLjPIMGsPM60jVe6YbqpF2o0vb8WhaZA8lhP2lTG3Y1KyaZ6f5
	 lVxKZEhK+jgpSJEnjlkd5XVIz214J+s6IErEuTP8r2CgoObOkXB7Yks5Bc9yz1U2fm
	 Ti3TFKPBJGBytoJ2FhC7EHXsOXlHEfheBJKGZ2DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 071/110] ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module
Date: Mon, 24 Apr 2023 15:17:33 +0200
Message-Id: <20230424131139.060200523@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit de6aa72b265b72bca2b1897d5000c8f0147d3157 upstream.

The original patch uses a feature in lib/vsprintf.c to handle the invalid
address when tring to print *_fw_module->man4_module_entry.name when the
*rc_fw_module is NULL.
This case is handled by check_pointer_msg() internally and turns the
invalid pointer to '(efault)' for printing but it is hiding useful
information about the circumstances. Change the print to emmit the name
of the widget and a note on which side's fw_module is missing.

Fixes: e3720f92e023 ("ASoC: SOF: avoid a NULL dereference with unsupported widgets")
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/alsa-devel/4826f662-42f0-4a82-ba32-8bf5f8a03256@kili.mountain/
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Link: https://lore.kernel.org/r/20230403090909.18233-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1687,10 +1687,12 @@ static int sof_ipc4_route_setup(struct s
 	int ret;
 
 	if (!src_fw_module || !sink_fw_module) {
-		/* The NULL module will print as "(efault)" */
-		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
-			src_fw_module->man4_module_entry.name,
-			sink_fw_module->man4_module_entry.name);
+		dev_err(sdev->dev,
+			"cannot bind %s -> %s, no firmware module for: %s%s\n",
+			src_widget->widget->name, sink_widget->widget->name,
+			src_fw_module ? "" : " source",
+			sink_fw_module ? "" : " sink");
+
 		return -ENODEV;
 	}
 


