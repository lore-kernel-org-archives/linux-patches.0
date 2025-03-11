Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1319925DD12;
	Tue, 11 Mar 2025 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705732; cv=none; b=WO1QcYAEceaniZ6PkEuXTfRJT9O29Zrw8xqddwR481uDeNmJInv6WzZGpkGsqd7ugDaW+lUz+RQSkUN3nnwAdGYUr/74Y7q5RrZY4hOOCxqyrjxje4hJCrsacad5Pmfvyl38XGTdI6+cxej5zXSuH34jyer19XpKQd+Pa20YGeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705732; c=relaxed/simple;
	bh=OaOVF6FnHAKdVxOggTM04jt1zmaqestm4/c658i/xgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZf9hAs2mrcOJh/Ucuo40qdnBlOHUWbfh1a3mU077qfrx6SDQP+TkAXkBKV93f/UyVtnOfH9seJ1+PwpM4VHRTk7xccBaowbrNrUQEuU6u0LFxr9KU+sGL+lKquDQNQTRVuItz3sKOT47Sso7GZGrI1bcODCGlpjLLG0ZD8jwvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apoTAfCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apoTAfCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31881C4CEE9;
	Tue, 11 Mar 2025 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705731;
	bh=OaOVF6FnHAKdVxOggTM04jt1zmaqestm4/c658i/xgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apoTAfCgsike3k/W0Nc6n8+ver6Iy+/haiBuz7FHcOThZiZ9u26hl82K0HS935VL9
	 C+GPLS7V6i1JM/aYydDMDOx+2BKY7EIdMz2FZIv9bYwdqHmXq4nHoSmMFgLLSW5bp1
	 1emlK8CUJEMlHdldsRdAUU3v/CYx7N/KLS+ww368=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 136/328] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Tue, 11 Mar 2025 15:58:26 +0100
Message-ID: <20250311145720.309782586@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b2a52e88ab0c9469eaadd4d4c8f57d072477820 upstream.

We submitted the command with TARGET_SCF_ACK_KREF, which requires
acknowledgment of command completion. If the command fails, make sure to
decrement the ref count.

Fixes: cff834c16d23 ("usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c667b4d9c8b0b580346a69ff53616b6a74cfea2.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -971,6 +971,7 @@ static void usbg_data_write_cmpl(struct
 	return;
 
 cleanup:
+	target_put_sess_cmd(se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 


