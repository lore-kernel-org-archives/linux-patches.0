Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEEF18E368;
	Mon, 28 Oct 2024 06:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097878; cv=none; b=UO7hAtR9UUnKLVkmUY8Vug7x8e4/zKGTytJjeXZ1dwg7tcQWD6vSiL4+VUs9oegQdYDPWcUZuIwticBhqeUQqp2tAa1ZNluH2JGq3RQeluhjETr9hXwb7K4Lv1JHHe9zxw6dde318d4/GVv+7Gg5qNJBimSZGM2ot2ZfyzgW6PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097878; c=relaxed/simple;
	bh=qlSABWMnpy5qWfXktyRat+PJoaYRq+zhqxFETLonDR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooGKvtLFNhSv06Hf1lD0k8xS1fLSftdS75wU7cyjnbYLD2mHGhVHPG1LSlp8xHjGXSJRCL7golcZcNpNU1U6A9CJylk2dIT19PmpGLGWqs1fQbv0hIc8cme4gKJm3oQbyuIcYRzlt1XGwA/hd15IY2pXmGaVUP+uY9woMLePnv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/QZ4HnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/QZ4HnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E88C4CEC3;
	Mon, 28 Oct 2024 06:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097877;
	bh=qlSABWMnpy5qWfXktyRat+PJoaYRq+zhqxFETLonDR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/QZ4HnWfNCfFDpHhvK2EmHuxs9PZKhLFHEFt5cgK5gtoqz4nJgChdl8vsR9+hkHO
	 MObbs02Fqusz+LhRu61EnJLwpygN6xDibezWsfMvkUG0LUqooTaHqtVFHyhsf+nHIG
	 DIp7WVorh9BRqbo8U4yzjIoWJI+hW1t2KPlc0e1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 6.6 188/208] x86/lam: Disable ADDRESS_MASKING in most cases
Date: Mon, 28 Oct 2024 07:26:08 +0100
Message-ID: <20241028062311.259897247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 3267cb6d3a174ff83d6287dcd5b0047bbd912452 upstream.

Linear Address Masking (LAM) has a weakness related to transient
execution as described in the SLAM paper[1]. Unless Linear Address
Space Separation (LASS) is enabled this weakness may be exploitable.

Until kernel adds support for LASS[2], only allow LAM for COMPILE_TEST,
or when speculation mitigations have been disabled at compile time,
otherwise keep LAM disabled.

There are no processors in market that support LAM yet, so currently
nobody is affected by this issue.

[1] SLAM: https://download.vusec.net/papers/slam_sp24.pdf
[2] LASS: https://lore.kernel.org/lkml/20230609183632.48706-1-alexander.shishkin@linux.intel.com/

[ dhansen: update SPECULATION_MITIGATIONS -> CPU_MITIGATIONS ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/5373262886f2783f054256babdf5a98545dc986b.1706068222.git.pawan.kumar.gupta%40linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2217,6 +2217,7 @@ config RANDOMIZE_MEMORY_PHYSICAL_PADDING
 config ADDRESS_MASKING
 	bool "Linear Address Masking support"
 	depends on X86_64
+	depends on COMPILE_TEST || !CPU_MITIGATIONS # wait for LASS
 	help
 	  Linear Address Masking (LAM) modifies the checking that is applied
 	  to 64-bit linear addresses, allowing software to use of the


