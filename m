Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456D22690D5;
	Sat, 30 May 2026 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160452; cv=none; b=aOMY+WSC+hixZ3HeX5wpVyQy2FBB6HMjIOxVCLNJcMSbRyl9Ts/QcmfMRmQd/1jTT2taPXgrTTGlp1Rg1OR0LVzFoK01XfgIU2+Dwk5mhcwduOf7c5+Pu2S/bXHulye7I3aQgqxhZMgpFQdK5ND9+6Ntyxg/dM8oQ/OtkpQJ5V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160452; c=relaxed/simple;
	bh=trw24b6tIK8P/0viJjF5sZUobXh89dEVqVnvc636rUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWeS8KzHARcyXfL86fPAGw0pZVFEVFJ8JBTQjCw/LKjnKdvuwMITXvbNMxENGJ7csbIkJ+f1L+Ub4iO9JDjgTh1R68JMrLS+E3sAWqOIQPcia6vHyYJEHJ55/uITgt9JdnltTLd1BsbDUvFpabU48sE42VVsZJlgGr1ceoNcANI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HT66DJV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HT66DJV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515301F00893;
	Sat, 30 May 2026 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160450;
	bh=J6rKmT1wagWDmYG5OiFbXIpYcknGk2rv0BE4mDGiCpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HT66DJV4DLKy2pe7ju+NsR4PRoDqzzHPav7+Kn6LG6VmsMciBimyaZl/M+dyvOY6k
	 kN5DEHrDkmWkz+Txa9QsG7gOOliqFdoftCug0cCTFtSQ3pYJYW8L+NJ8VvVoG/WdiJ
	 5qX3qYwTK+VeIGLJewMXkhdHUSjKmxe/6VErgfsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 311/969] usb: ulpi: fix memory leak on ulpi_register() error paths
Date: Sat, 30 May 2026 17:57:15 +0200
Message-ID: <20260530160309.006910917@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 0b9fcab1b8608d429e5f239afb197de928d4de7d upstream.

Commit 01af542392b5 ("usb: ulpi: fix double free in
ulpi_register_interface() error path") removed kfree(ulpi) from
ulpi_register_interface() to fix a double-free when device_register()
fails.

But when ulpi_of_register() or ulpi_read_id() fail before
device_register() is called, the ulpi allocation is leaked.

Add kfree(ulpi) on both error paths to properly clean up the allocation.

Fixes: 01af542392b5 ("usb: ulpi: fix double free in ulpi_register_interface() error path")
Cc: stable <stable@kernel.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260407-ulpi-v1-1-f3fafe53f7b2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -286,12 +286,15 @@ static int ulpi_register(struct device *
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret)
+	if (ret) {
+		kfree(ulpi);
 		return ret;
+	}
 
 	ret = ulpi_read_id(ulpi);
 	if (ret) {
 		of_node_put(ulpi->dev.of_node);
+		kfree(ulpi);
 		return ret;
 	}
 


