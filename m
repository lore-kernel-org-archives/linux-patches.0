Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526E30148B;
	Sat, 30 May 2026 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162170; cv=none; b=p6XplTyndI0cu0AaK6CFzmRJaCE4Ujad6vcXm59vpNGOvBy/aiZieLR25IycqSsnmzFnToYkB9fgMyf92XXAHtN0hR5M2dPqOsRCWtPzo+xxDiRgnr25iCFnNfyc0tc1Ar+lTzqK0i94xxibqdh/hGehXEQ445t0/dI2Jsj7+/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162170; c=relaxed/simple;
	bh=oftSnuXte5T4cCL8GOqZVQlQFLDJfY3RF2RTUb9gMQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFSuZ+PaplHevqHgDIS9nDX++PlmR2IubWcMJ7QbVzYW6zNVEafqHyGzBcFsyCX0Lgbam2KU69vHRtryTZFxBud30H8klwF9kZREYPiYFQyi+dnkZDx+/ssdWgCGNxfuJWW3CDJIJz/spBwODmwzl8rgYs/URDUK0puAIsYkbyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj/k3cYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj/k3cYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFE91F00893;
	Sat, 30 May 2026 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162169;
	bh=606frkdeBYvTkrKMxWejD3QtWMQeMwz1Gc6ZU6O+caQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sj/k3cYZxtjRENAoUhNjXc/vH0lvZ2oUwFY+bFsppj3nXijEutAmxDRdkUO+/+LCE
	 7KXB23Qcuxoj839XFRtucQ0ZpQR6B0avhpGqaYcMuCK6+PG/vtk2D8jd681C6V6+nj
	 42mvyRunGeZnfgFwZNkpasft302MizByVdacv8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 842/969] ALSA: asihpi: Fix potential OOB array access at reading cache
Date: Sat, 30 May 2026 18:06:06 +0200
Message-ID: <20260530160323.905693466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


