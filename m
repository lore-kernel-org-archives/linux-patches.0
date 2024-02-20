Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8FC14F9DA;
	Tue, 20 Feb 2024 21:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462895; cv=none; b=eSw9/G6orLrD2rk51ChJj5CiNaV6nXuTrJlEsgKSOsSQO/fSVCdYkTri49pkMHM8+jkP4hGV9V7zCtA0crfHUzy0eQezek3lawurgvMDIt+/ktHqdwI5BfoLt1rncSI48PQKtnhJrvzC5/S6ZEVWWssskhH8vpz+xCqb43Pq4SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462895; c=relaxed/simple;
	bh=9M4pBAp9mjWwbQZGXzcCeiAq08U+CTrRNZE3U+NCSNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1i7Uf9jmkPjlC6Cgkvu2z4+QMY7Fhjo9UWZf5HCJ7U/di5Q4DLptODx8o426v4arM5OxqiTzr8KEh1l2mo111Ju9OA0HhyleuwxKTHvqw6TR9ARv4f60++CfRdfEoA7NSPNNgQDXZatfKnLrHQ7gnLpm6o0R4V+GmkHjuWZpLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yy5EDHHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yy5EDHHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68242C43390;
	Tue, 20 Feb 2024 21:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462894;
	bh=9M4pBAp9mjWwbQZGXzcCeiAq08U+CTrRNZE3U+NCSNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yy5EDHHUEvubTUpqogWOa+/w9m6IK20/B9VZkNGaIY6AFKOr/9OzNd+fyPmN5H9nf
	 PBcAyBigz+O4IloEmvaAEBbsGifHbxaeakPEKn2UVJl1gWEH9pzVTjr/J3jNopBF7g
	 B2aqS1zXWJVM/Dne9lhHmSb+G75C1XnqlHk3xjls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 041/197] parisc: Prevent hung tasks when printing inventory on serial console
Date: Tue, 20 Feb 2024 21:50:00 +0100
Message-ID: <20240220204842.309140225@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit c8708d758e715c3824a73bf0cda97292b52be44d upstream.

Printing the inventory on a serial console can be quite slow and thus may
trigger the hung task detector (CONFIG_DETECT_HUNG_TASK=y) and possibly
reboot the machine. Adding a cond_resched() prevents this.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/drivers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -1003,6 +1003,9 @@ static __init int qemu_print_iodc_data(s
 
 	pr_info("\n");
 
+	/* Prevent hung task messages when printing on serial console */
+	cond_resched();
+
 	pr_info("#define HPA_%08lx_DESCRIPTION \"%s\"\n",
 		hpa, parisc_hardware_description(&dev->id));
 


