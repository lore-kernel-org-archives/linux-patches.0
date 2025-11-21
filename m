Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0034E2745E;
	Fri, 21 Nov 2025 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731965; cv=none; b=EB1Ogf3IyAZYE/1GTBzhyJ/wcLlAXNLTfryXvjE8A24umbYWtbqbCbokDLakktux8dLSu0AYDVLWB6PJod6Y7SPAf3rB3Iqdoi/YXg3iXwDD0gutbXMcDzkj+aZgGlTlG82zscY+8UID445usQqWrutT0H8VYBkmts51CFd1r3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731965; c=relaxed/simple;
	bh=NUQOsaB0oeRvnajkYaD1WIWJnWCbP3U+slRA1ka9Mj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awQTMn4+9VFOQYKdI/sOr5+9pYyn4kgONrrvI+n17r858chTj+HpL+TDaf533r/XRzqiEMy9Ctx7b5+Ky4C1G78yzRE6ut8MUqY00uPvfK3+HWnnltHXy3Lv9ZjYR/HcEx52TNpHzHw+2R9rc6IhU1rpsRYMLZNBQ3maiTeBbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aV9TY7r5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aV9TY7r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDF4C4CEF1;
	Fri, 21 Nov 2025 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731964;
	bh=NUQOsaB0oeRvnajkYaD1WIWJnWCbP3U+slRA1ka9Mj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aV9TY7r5OrEpuUlSac7QktcwMIuFAeB57m6LEY+mriAtyCMSwcL1Z7x48Q9KCFeiD
	 Ke6sdsP9GUH5eqYFHfxxw51xQmD9NRZrRTv40xAOEgTZtci8dQLYlp6iJyc2Y0vxm6
	 cb15EVlIBG+CyuOWjH8qP6b5b8DZjWE+qCZE8uaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Askar Safin <safinaskar@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 142/185] PM: hibernate: Emit an error when image writing fails
Date: Fri, 21 Nov 2025 14:12:49 +0100
Message-ID: <20251121130148.999436671@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 62b9ca1706e1bbb60d945a58de7c7b5826f6b2a2 upstream.

If image writing fails, a return code is passed up to the caller, but
none of the callers log anything to the log and so the only record
of it is the return code that userspace gets.

Adjust the logging so that the image size and speed of writing is
only emitted on success and if there is an error, it's saved to the
logs.

Fixes: a06c6f5d3cc9 ("PM: hibernate: Move to crypto APIs for LZO compression")
Reported-by: Askar Safin <safinaskar@gmail.com>
Closes: https://lore.kernel.org/linux-pm/20251105180506.137448-1-safinaskar@gmail.com/
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Askar Safin <safinaskar@gmail.com>
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
[ rjw: Added missing braces after "else", changelog edits ]
Link: https://patch.msgid.link/20251106045158.3198061-2-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/swap.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -882,11 +882,14 @@ out_finish:
 	stop = ktime_get();
 	if (!ret)
 		ret = err2;
-	if (!ret)
+	if (!ret) {
+		swsusp_show_speed(start, stop, nr_to_write, "Wrote");
+		pr_info("Image size after compression: %d kbytes\n",
+			(atomic_read(&compressed_size) / 1024));
 		pr_info("Image saving done\n");
-	swsusp_show_speed(start, stop, nr_to_write, "Wrote");
-	pr_info("Image size after compression: %d kbytes\n",
-		(atomic_read(&compressed_size) / 1024));
+	} else {
+		pr_err("Image saving failed: %d\n", ret);
+	}
 
 out_clean:
 	hib_finish_batch(&hb);


