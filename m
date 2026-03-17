Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43EA191F94;
	Tue, 17 Mar 2026 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767924; cv=none; b=FEi8XONrqcoXjm3dAMcepGt/uzaFfO7ra4ab9CjsswrQuQ8LFuJXjzEVj2uEtZndQEM5FDPJMK5Igc6j701tFceG4RCKo3cJABvos3eZucXFFjJwPy8CG1T2iBysc/5UC9T/lZ/alNh7ul+ZV+VtAKR59Sv55HO8cIFSg28APJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767924; c=relaxed/simple;
	bh=5LCcUk5CWPvW/vXfOJMGoseCSVLZbJJ+yNBPj+RVPtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSvYKL9S50VttCwITb+evzR+HlOQ0o9/qzyK2p/mTttlBYBx7g3v5VEPQR3zfXHdEULRqTnKfQfMboRSYZmawGweYkk+jsTlsPE40N3/QGNoTzbrhKdw2kiFaVoru04dyPyAt9MjEXAZPcpybaFo6kGT+OO7zzE1wrqOQrqb1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5wrd7v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5wrd7v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C241C4CEF7;
	Tue, 17 Mar 2026 17:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767923;
	bh=5LCcUk5CWPvW/vXfOJMGoseCSVLZbJJ+yNBPj+RVPtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5wrd7v1tm/OynS4M+TQ9Gjsbz3nyjHyz3LhodjMlE5zLQCHjK846diNGpEu0LQJc
	 ERbhRX2RggzTZNp9ocl57Fr1/m2ryL8dcTYb0g1IeO7hweDpZeD4gTcitXhHxWQNRw
	 WlMn9ShgpllcvmdL44EBMfnFUtl0k4Gfmie4yD4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.18 191/333] ipmi:si: Handle waiting messages when BMC failure detected
Date: Tue, 17 Mar 2026 17:33:40 +0100
Message-ID: <20260317163006.440213959@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 52c9ee202edd21d0599ac3b5a6fe1da2a2f053e5 upstream.

If a BMC failure is detected, the current message is returned with an
error.  However, if there was a waiting message, it would not be
handled.

Add a check for the waiting message after handling the current message.

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Reported-by: Rafael J. Wysocki <rafael@kernel.org>
Closes: https://lore.kernel.org/linux-acpi/CAK8fFZ58fidGUCHi5WFX0uoTPzveUUDzT=k=AAm4yWo3bAuCFg@mail.gmail.com/
Fixes: bc3a9d217755 ("ipmi:si: Gracefully handle if the BMC is non-functional")
Cc: stable@vger.kernel.org # 4.18
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -810,6 +810,12 @@ restart:
 			 */
 			return_hosed_msg(smi_info, IPMI_BUS_ERR);
 		}
+		if (smi_info->waiting_msg != NULL) {
+			/* Also handle if there was a message waiting. */
+			smi_info->curr_msg = smi_info->waiting_msg;
+			smi_info->waiting_msg = NULL;
+			return_hosed_msg(smi_info, IPMI_BUS_ERR);
+		}
 		smi_mod_timer(smi_info, jiffies + SI_TIMEOUT_HOSED);
 		goto out;
 	}


