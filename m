Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8CA7E110;
	Tue, 29 Apr 2025 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946094; cv=none; b=qpXvRLc1pkrtPTQ5EUZFdqLkDLd0yMqUwbgfVx+LX9/lzLgyRbaJWdE5dHvG8ZIY7qnBC6Xviy+Y1ieNwpg6MckmoKzaei0PypxKZuTA3F1VFt1PdxvytjsKc/meAFsg7VD3FKGkuiVMbjkP9kSLugprLzfNYGuLw3myOBD/efA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946094; c=relaxed/simple;
	bh=Ufi5vIWrMIu+2wh35DutQ4JNOgWWnsiIkGLFLSG5pLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMZpe3iz9fChGrOJsyBoV9mrInBmH1RzG4uw0zCvDR+9w7EKWawr+j1CaDTLUmEnEEucxukFn2WR7D38ZrTCTK2AEAkwZq7HGcZ2yVmemacOD1jOu/DQY2u0o5xHDw9L/LxNwe5sySxnL9H4uRyRFAi+7l6emySq+OBlQuhmo50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtX1KFqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtX1KFqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1995C4CEE3;
	Tue, 29 Apr 2025 17:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946094;
	bh=Ufi5vIWrMIu+2wh35DutQ4JNOgWWnsiIkGLFLSG5pLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtX1KFqLc6k4KoXWHG5auyUTHDJUFk0Gq0ROll4q7cGOWUFiS3KRrJ1pc6+RzhEr9
	 z2e9J06i3KHfVXTjTEvGWhStXHqupPr6RI8bzZrhovEYTpf0kyLVSt0bkCLtDoVR0P
	 AS7A6CPRDjT7fksyOdfOWoqsQfG9geCIOs2frQ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjith Pananchikkal <renjith.pananchikkal@amd.com>,
	Mark Pearson <mpearson@lenovo.com>,
	David Ober <dober@lenovo.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 122/311] drm/amd/display: Fix ACPI edid parsing on some Lenovo systems
Date: Tue, 29 Apr 2025 18:39:19 +0200
Message-ID: <20250429161126.036239887@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 870bea21fdf88f45c94c0a3dbb0e3cc1b219680f upstream.

[Why]
The ACPI EDID in the BIOS of a Lenovo laptop includes 3 blocks, but
dm_helpers_probe_acpi_edid() has a start that is 'char'.  The 3rd
block index starts after 255, so it can't be indexed properly.
This leads to problems with the display when the EDID is parsed.

[How]
Change the variable type to 'short' so that larger values can be indexed.

Cc: Renjith Pananchikkal <renjith.pananchikkal@amd.com>
Reported-by: Mark Pearson <mpearson@lenovo.com>
Suggested-by: David Ober <dober@lenovo.com>
Fixes: c6a837088bed ("drm/amd/display: Fetch the EDID from _DDC if available for eDP")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a918bb4a90d423ced2976a794f2724c362c1f063)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -912,7 +912,7 @@ dm_helpers_probe_acpi_edid(void *data, u
 {
 	struct drm_connector *connector = data;
 	struct acpi_device *acpidev = ACPI_COMPANION(connector->dev->dev);
-	unsigned char start = block * EDID_LENGTH;
+	unsigned short start = block * EDID_LENGTH;
 	struct edid *edid;
 	int r;
 


