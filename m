Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFE931618C;
	Thu, 28 May 2026 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998022; cv=none; b=e3/FQuYO9IfsKd5D4og5dC7OX8/iqGtgs4BsoYS1mLkHD2WPEAlCqEZath3vDoqAYdx7sgi90F+EA/hSp6Akw4hcUVyO9Ckg7T+ZE0TVrOjL/UweIJSJr2rxyBvzo6AFhEtfdip1dAb2iEehmuQ1O6XWxNdyd5ni5L1mvkEKNPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998022; c=relaxed/simple;
	bh=0JCJ1CVVaheygx4Ee2SPsJQ8LQHPVcjlFvx4XkYBBUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D49ZFFFWOI6zacT5y5dTx1J6rgfsM0Kv0g6GGtAvYsNCbnl3VQW9l9KgDUL8dJuxhv7gpowKwAJjKVWXrh8YFBAdnE5HGoGkc9RF/NtIbOtDNkBy8cFC6ww/JqPDR0snWs+5nCXTF1EUQgp8/e3Q33KzkWbj4j47dHx7PmClj58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAsGPlos; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAsGPlos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB391F00A3A;
	Thu, 28 May 2026 19:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998021;
	bh=SkkOo15uf4Gw850QzllTmNyIqKIFuJ9vBUQMzDmsi8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAsGPlosCHQvxPIEre4JVH7C1NLxUAicO3eMJbhn6f8kWVfiwZuio0DU+aAWNugkN
	 CF2nkSguolIkwjImDK/z9QC/919KL43xUnhne59+bOHRam2bY/7lAgOHrjaaDKmSbc
	 //0j9R8FIdBs94VKkdMq+TcHfGi43UiyYf56899o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 025/461] ALSA: asihpi: Fix potential OOB array access at reading cache
Date: Thu, 28 May 2026 21:42:34 +0200
Message-ID: <20260528194647.616133173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


