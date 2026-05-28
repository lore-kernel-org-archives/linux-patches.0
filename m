Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BDB2D6E5C;
	Thu, 28 May 2026 20:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999462; cv=none; b=MK9ChNCyBWqgSoxcK7e8hKuAPozScD8CqpYbOLGH5RawkV0Pr06PfkaKNc1thI9IMOFEzwGBcBLxGj8/cq2nL/yqmgVULreQ4syaB1yWZul5GkaIE1DCytH74V7ec98R//M1DaVTUUWlkc9tVFS2ASnPJhbIUSC16nqWEwJagVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999462; c=relaxed/simple;
	bh=KOPc0EDEf2brrhKNn4J9QaQEyyaWBRdi7Tbw+mm9efg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoUAedKe0YPwgIANhzG5jTEo+XhqkOVrnxus1QgI0sWEr7wi21/OLCJme43N1y+5rF59TmeOPxWUC/E5fhoNp8u1ZMKWbsElgEC4xxQK64z6+MY1K4Flu2HxHHN4PO4nVSkd0/q/Rqcyh8UA+u115JuLOkf4lmWdFOnTy0Kzp/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+Oc3twR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+Oc3twR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868C81F000E9;
	Thu, 28 May 2026 20:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999461;
	bh=gDbbpZL9glwXp3k3Zuiv6FcnVJExZ7PYf7PMkxOrETs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+Oc3twRTXdB5b3TM0lrtYPb8gAAbhMYAACGZAxnY8fgoa6KMQhYpyxbpOv5WiwV1
	 xHFlEKMy0KdOORPDhTx0LCAQqm5DgOKrondKC9sNAU+aIBJmOSIF15LscXuKzfbvYR
	 XgTtqsV0g83YwGuZAv1LOKSwVwUVYq8rKKto7t5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 039/377] ALSA: asihpi: Fix potential OOB array access at reading cache
Date: Thu, 28 May 2026 21:44:37 +0200
Message-ID: <20260528194639.508010800@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 7b7d6572145c1dab2dd9bfb550b188e5f0ff3c3f upstream.

find_control() to retrieve a cached info accesses the array with the
given index blindly, which may lead to an OOB array access.
Add a sanity check for avoiding it.

Link: https://sashiko.dev/#/patchset/20260511230121.28606-1-rosenp%40gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260515085606.242284-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/asihpi/hpicmn.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/asihpi/hpicmn.c
+++ b/sound/pci/asihpi/hpicmn.c
@@ -276,6 +276,12 @@ static short find_control(u16 control_in
 		return 0;
 	}
 
+	if (control_index >= p_cache->control_count) {
+		HPI_DEBUG_LOG(VERBOSE, "control_index out of bounce %d\n",
+			control_index);
+		return 0;
+	}
+
 	*pI = p_cache->p_info[control_index];
 	if (!*pI) {
 		HPI_DEBUG_LOG(VERBOSE, "Uncached Control %d\n",


