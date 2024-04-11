Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09161E48E;
	Thu, 11 Apr 2024 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832516; cv=none; b=S0g7XhIAs09NIudkG778VtnmOA0S4bvjSGTJDsTf/qqzNUdqZN+brkApMhJj0lRIjUa9zC7oqkfQgJtqTgtNvjjXhtxoKVFxvF5QcX6PzxInYs7XEugTiHcDTSc2CsElk/ez5oCD1ERPVPtEw6JOeTFQGNhoR5+vsinmfB3yHqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832516; c=relaxed/simple;
	bh=XsPjSUXKgfLZIHDXtJTug0OHMD/aj9wAmRxiMmHoAlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ene7iCJqlSY6lHR8fckwTYTMgDPzfJ9yij0RpZP10ViEMPBq5MUrrMwDZ+wY1firVFVbh1gIqic+tISPni9gTPvuURJjpRsD7iOm+TFbK+57kK6C3YgvFt3RpFMtRbEWq+sQN8fnmD4FjhC8XDoDYQT4uEopJxQOiomyz/AYbUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJqNWx8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJqNWx8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58091C43390;
	Thu, 11 Apr 2024 10:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832516;
	bh=XsPjSUXKgfLZIHDXtJTug0OHMD/aj9wAmRxiMmHoAlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJqNWx8ku+lCdVW7gEiia6GF5xFrPQm3SajphstQtmx+MlGNQzWa/6Xv1rqjBx7Iq
	 GVFqRQg6jLpBQP7pFo+NNMrFluIQXcCzh71f82HmM+B32KDLFJsWWFf41vc79MX6yd
	 1Z0awWqnx/LVrBWH+OFZIGA1ljuiHb1SA0hd8ch0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 73/83] gcc-plugins/stackleak: Avoid .head.text section
Date: Thu, 11 Apr 2024 11:57:45 +0200
Message-ID: <20240411095414.884192507@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit e7d24c0aa8e678f41457d1304e2091cac6fd1a2e upstream.

The .head.text section carries the startup code that runs with the MMU
off or with a translation of memory that deviates from the ordinary one.
So avoid instrumentation with the stackleak plugin, which already avoids
.init.text and .noinstr.text entirely.

Fixes: 48204aba801f1b51 ("x86/sme: Move early SME kernel encryption handling into .head.text")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202403221630.2692c998-oliver.sang@intel.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240328064256.2358634-2-ardb+git@google.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/stackleak_plugin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -467,6 +467,8 @@ static bool stackleak_gate(void)
 			return false;
 		if (STRING_EQUAL(section, ".entry.text"))
 			return false;
+		if (STRING_EQUAL(section, ".head.text"))
+			return false;
 	}
 
 	return track_frame_size >= 0;


