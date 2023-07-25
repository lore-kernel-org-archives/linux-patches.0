Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D51D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE9DC433C8;
	Tue, 25 Jul 2023 11:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283244;
	bh=hMSmt+hKimVaFa890FWl4JHL/3sItptPduskqAlanqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYzIptfASg5K4DdFilNLjA0W4XcxBwAh2T9D61I8fnmypw7f9gLhnpw78P3+SsP/h
	 4SVGfKeh6Aw8GlkQc45+wilAL5Z+lhPQb0TdkQrPPpUX2Hcf+4Iy3oMFVkWDI+VRQw
	 +oCHSGnxZN+sJu0F+6UAPWjCLNv0R3VezaK/vJ2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 165/183] tracing/histograms: Return an error if we fail to add histogram to hist_vars list
Date: Tue, 25 Jul 2023 12:46:33 +0200
Message-ID: <20230725104513.730424482@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mohamed Khalfella <mkhalfella@purestorage.com>

commit 4b8b3905165ef98386a3c06f196c85d21292d029 upstream.

Commit 6018b585e8c6 ("tracing/histograms: Add histograms to hist_vars if
they have referenced variables") added a check to fail histogram creation
if save_hist_vars() failed to add histogram to hist_vars list. But the
commit failed to set ret to failed return code before jumping to
unregister histogram, fix it.

Link: https://lore.kernel.org/linux-trace-kernel/20230714203341.51396-1-mkhalfella@purestorage.com

Cc: stable@vger.kernel.org
Fixes: 6018b585e8c6 ("tracing/histograms: Add histograms to hist_vars if they have referenced variables")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6560,7 +6560,8 @@ static int event_hist_trigger_parse(stru
 		goto out_unreg;
 
 	if (has_hist_vars(hist_data) || hist_data->n_var_refs) {
-		if (save_hist_vars(hist_data))
+		ret = save_hist_vars(hist_data);
+		if (ret)
 			goto out_unreg;
 	}
 


